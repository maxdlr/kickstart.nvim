-- Custom Telescope entry_makers that highlight path segments independently and
-- decorate results with a filetype icon and (optionally) git status.
--
-- Both makers wrap Telescope's built-in entry makers and override *only* the
-- `display` function. Wrapping (rather than returning a bare table) preserves
-- the built-in path/filename/lnum/col resolution, so opening a result on <CR>
-- still jumps to the correct file and location.
--
-- Usage:
--   local em = require 'plugins.telescope-entry-maker'
--   builtin.find_files { entry_maker = em.file_entry_maker { cwd = some_dir } }
--   builtin.live_grep  { entry_maker = em.grep_entry_maker { cwd = some_dir } }
--
-- Decorations:
--   * Filetype icons come from nvim-web-devicons when available (no-op if not).
--   * Git status is resolved once per picker open via `git status --porcelain`
--     (a single subprocess call, skipped outside git repos). Disable with
--     `{ git = false }` if the call is undesirable in a huge/slow repo.

local entry_display = require 'telescope.pickers.entry_display'
local make_entry = require 'telescope.make_entry'

local has_devicons, devicons = pcall(require, 'nvim-web-devicons')

local M = {}

--- Splits a path into its parent directory, filename (without extension), and
--- extension. The parent dir includes a trailing slash; the extension includes
--- its leading dot. A path with no separator returns an empty dir. A name with
--- no extension — or a dotfile like `.gitignore` — returns an empty extension.
---
--- @param path string
--- @return string dir  parent directory including trailing slash, or '' if none
--- @return string name filename without its extension
--- @return string ext  extension including the leading dot, or '' if none
local function split_path(path)
  local dir, tail = path:match '^(.*)/([^/]*)$'
  if not dir then
    dir, tail = '', path
  else
    dir = dir .. '/'
  end

  -- Greedy `.+` before the final dot means the split happens at the *last* dot,
  -- so `archive.tar.gz` -> ('archive.tar', '.gz'). Requiring at least one char
  -- before the dot means a leading-dot dotfile (`.gitignore`) has no extension.
  local name, ext = tail:match '^(.+)%.([^.]+)$'
  if not name then
    name, ext = tail, ''
  else
    ext = '.' .. ext
  end

  return dir, name, ext
end

--- Returns a filetype icon and its highlight group for a filename.
--- Returns empty strings when nvim-web-devicons is unavailable.
---
--- @param filename string
--- @return string icon
--- @return string hl_group
local function file_icon(filename)
  if not has_devicons then return '', '' end
  local icon, hl = devicons.get_icon(filename, nil, { default = true })
  return icon or '', hl or ''
end

--- Builds a map of absolute-path -> two-char git status code for the repo
--- containing `cwd`. Returns an empty map when `cwd` is not inside a git repo
--- or git is unavailable. Runs a single `git status --porcelain` call.
---
--- @param cwd string directory to resolve the repo from
--- @return table<string, string> status_by_path
local function git_status_map(cwd)
  local map = {}

  local root = vim.fn.systemlist { 'git', '-C', cwd, 'rev-parse', '--show-toplevel' }[1]
  if vim.v.shell_error ~= 0 or not root or root == '' then return map end

  local lines = vim.fn.systemlist { 'git', '-C', cwd, 'status', '--porcelain' }
  if vim.v.shell_error ~= 0 then return map end

  for _, line in ipairs(lines) do
    -- Porcelain v1 format: "XY <path>", where paths are relative to repo root.
    local xy = line:sub(1, 2)
    local rel = line:sub(4)
    -- Renames/copies are shown as "old -> new"; key on the new path.
    local arrow = rel:find ' %-> '
    if arrow then rel = rel:sub(arrow + 4) end
    map[vim.fs.normalize(root .. '/' .. rel)] = xy
  end

  return map
end

--- Maps a two-char git status code to a single-char symbol and highlight group.
---
--- @param xy string|nil two-char porcelain status code
--- @return string symbol
--- @return string hl_group
local function git_symbol(xy)
  if not xy or xy == '' then return '', '' end
  local staged, unstaged = xy:sub(1, 1), xy:sub(2, 2)
  if xy == '??' then return '?', 'TelescopeGitUntracked' end
  if staged == 'A' then return '+', 'TelescopeGitAdded' end
  if staged == 'D' or unstaged == 'D' then return '-', 'TelescopeGitDeleted' end
  if staged == 'R' then return '', 'TelescopeGitRenamed' end
  if staged == 'M' or unstaged == 'M' then return '●', 'TelescopeGitModified' end
  return '•', 'TelescopeGitModified'
end

--- Builds an entry_maker for file-path pickers (find_files, oldfiles, git_files).
--- Prefixes a filetype icon, colors the parent dir / filename / extension with
--- separate highlight groups, and appends a git status symbol.
---
--- The picker's `cwd` must be passed through in `opts` so the underlying maker
--- resolves paths against the same directory the picker searches.
---
--- @param opts table|nil forwarded to gen_from_file (e.g. cwd); `git = false` disables git status
--- @return function entry_maker
function M.file_entry_maker(opts)
  opts = opts or {}
  local base_maker = make_entry.gen_from_file(opts)
  local status = opts.git ~= false and git_status_map(opts.cwd or vim.uv.cwd()) or {}

  local displayer = entry_display.create {
    separator = '',
    items = {
      { width = 2 }, -- icon
      { width = nil }, -- parent dir
      { width = nil }, -- filename (no extension)
      { width = nil }, -- extension
      { remaining = true }, -- git status
    },
  }

  local make_display = function(entry)
    local dir, name, ext = split_path(entry.value)
    local icon, icon_hl = file_icon(name .. ext)
    local sym, sym_hl = git_symbol(status[vim.fs.normalize(entry.path)])
    return displayer {
      { icon, icon_hl },
      { dir, 'TelescopeParentDir' },
      { name, 'TelescopeResultsIdentifier' },
      { ext, 'TelescopeFileExt' },
      { sym ~= '' and ('  ' .. sym) or '', sym_hl },
    }
  end

  return function(line)
    local entry = base_maker(line)
    entry.display = make_display
    return entry
  end
end

--- Builds an entry_maker for grep pickers (live_grep, grep_string).
--- Prefixes a filetype icon and git status, colors the parent dir / filename /
--- extension / coordinates / matched text with separate highlight groups.
---
--- The picker's `cwd` must be passed through in `opts` so the underlying maker
--- resolves paths against the same directory the picker searches.
---
--- @param opts table|nil forwarded to gen_from_vimgrep (e.g. cwd); `git = false` disables git status
--- @return function entry_maker
function M.grep_entry_maker(opts)
  opts = opts or {}
  local base_maker = make_entry.gen_from_vimgrep(opts)
  local status = opts.git ~= false and git_status_map(opts.cwd or vim.uv.cwd()) or {}

  local displayer = entry_display.create {
    separator = '',
    items = {
      { width = 2 }, -- icon
      { width = 2 }, -- git status
      { width = nil }, -- parent dir
      { width = nil }, -- filename (no extension)
      { width = nil }, -- extension
      { width = nil }, -- :lnum:col:
      { remaining = true }, -- matched text
    },
  }

  local make_display = function(entry)
    local dir, name, ext = split_path(entry.filename)
    local icon, icon_hl = file_icon(name .. ext)
    local sym, sym_hl = git_symbol(status[vim.fs.normalize(entry.path)])
    -- entry.lnum / entry.col are computed lazily by the wrapped maker.
    local coords = string.format(':%s:%s:', entry.lnum or '', entry.col or '')
    return displayer {
      { icon, icon_hl },
      { sym, sym_hl },
      { dir, 'TelescopeParentDir' },
      { name, 'TelescopeResultsIdentifier' },
      { ext, 'TelescopeFileExt' },
      { coords, 'TelescopeResultsLineNr' },
      { ' ' .. (entry.text or ''), 'TelescopeResultsComment' },
    }
  end

  return function(line)
    local entry = base_maker(line)
    entry.display = make_display
    return entry
  end
end

return M
