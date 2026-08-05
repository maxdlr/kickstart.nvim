-- Custom Telescope entry_makers that highlight path segments independently.
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

local entry_display = require 'telescope.pickers.entry_display'
local make_entry = require 'telescope.make_entry'

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

--- Builds an entry_maker for file-path pickers (find_files, oldfiles, git_files).
--- Colors the parent directory and filename with separate highlight groups.
---
--- The picker's `cwd` must be passed through in `opts` so the underlying maker
--- resolves paths against the same directory the picker searches.
---
--- @param opts table|nil options forwarded to telescope's gen_from_file (e.g. cwd)
--- @return function entry_maker
function M.file_entry_maker(opts)
  opts = opts or {}
  local base_maker = make_entry.gen_from_file(opts)

  local displayer = entry_display.create {
    separator = '',
    items = {
      { width = nil }, -- parent dir
      { width = nil }, -- filename (no extension)
      { remaining = true }, -- extension
    },
  }

  local make_display = function(entry)
    local dir, name, ext = split_path(entry.value)
    return displayer {
      { dir, 'TelescopeParentDir' },
      { name, 'TelescopeResultsIdentifier' },
      { ext, 'TelescopeFileExt' },
    }
  end

  return function(line)
    local entry = base_maker(line)
    entry.display = make_display
    return entry
  end
end

--- Builds an entry_maker for grep pickers (live_grep, grep_string).
--- Colors the parent directory, filename, line:col coordinates, and matched
--- text with separate highlight groups.
---
--- The picker's `cwd` must be passed through in `opts` so the underlying maker
--- resolves paths against the same directory the picker searches.
---
--- @param opts table|nil options forwarded to telescope's gen_from_vimgrep (e.g. cwd)
--- @return function entry_maker
function M.grep_entry_maker(opts)
  opts = opts or {}
  local base_maker = make_entry.gen_from_vimgrep(opts)

  local displayer = entry_display.create {
    separator = '',
    items = {
      { width = nil }, -- parent dir
      { width = nil }, -- filename (no extension)
      { width = nil }, -- extension
      { width = nil }, -- :lnum:col:
      { remaining = true }, -- matched text
    },
  }

  local make_display = function(entry)
    local dir, name, ext = split_path(entry.filename)
    -- entry.lnum / entry.col are computed lazily by the wrapped maker.
    local coords = string.format(':%s:%s:', entry.lnum or '', entry.col or '')
    return displayer {
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
