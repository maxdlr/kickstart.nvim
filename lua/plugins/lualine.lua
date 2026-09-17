vim.pack.add { Gh 'nvim-lualine/lualine.nvim' }

-- Start from the built-in horizon theme and override the `a` section colors
-- (per-mode) instead of using the theme's defaults.
local horizon = require 'lualine.themes.horizon'
local theme = vim.deepcopy(horizon)

local red = '#FF0055'
local dark = '#2E303E'
local yellow = '#F4EF00'
local green = '#00FF55'
local orange = '#FFAA00'
local white = '#FFFFFF'

---@param mode string
---@param when_active? { bg: string, fg: string }
local function set_colors_by_mode(mode, when_active)
  local local_when_active = {
    bg = (when_active and when_active.bg) or red,
    fg = (when_active and when_active.fg) or dark,
  }

  if theme[mode] and theme[mode].a then
    theme[mode].a.bg = local_when_active.bg
    theme[mode].c.fg = local_when_active.fg
  end
end

-- Sections, from outer to inner:
-- a = mode indicator,
-- b = branch/git info,
-- c = filename/central content,
-- z = mirrors `a` on the opposite side.
--
-- control all mode colors in one place, instead of having to set them individually for each mode
for _, mode in ipairs { 'normal', 'insert', 'visual', 'replace', 'command', 'terminal' } do
  theme.inactive.a.bg = dark
  theme.inactive.a.fg = red

  if theme[mode] then
    if mode == 'normal' then
      set_colors_by_mode(mode)
    elseif mode == 'insert' then
      set_colors_by_mode(mode, { bg = green, fg = dark })
    elseif mode == 'visual' then
      set_colors_by_mode(mode, { bg = yellow, fg = dark })
    elseif mode == 'replace' then
      set_colors_by_mode(mode, { bg = red, fg = dark })
    elseif mode == 'command' then
      set_colors_by_mode(mode, { bg = orange, fg = dark })
    elseif mode == 'terminal' then
      set_colors_by_mode(mode, { bg = white, fg = dark })
    end
  end
end

-- Inactive tabs render with theme.inactive.a, which horizon sets to a
-- near-black-on-dark-gray combo (barely visible against the tabline
-- background). Give it its own readable colors instead.
-- theme.inactive.a.bg = '#2E303E'
-- theme.inactive.a.fg = '#FF0055'

local function repo_name()
  local root = vim.fs.root(0, '.git')
  if not root then return vim.fn.fnamemodify(vim.fn.getcwd(), ':t') end
  return vim.fn.fnamemodify(root, ':t')
end

require('lualine').setup {
  options = {
    theme = theme,
    globalstatus = true,
    always_show_tabline = true,
  },
  extensions = { 'quickfix', 'fzf', 'neo-tree', 'toggleterm', 'trouble' },
  tabline = {
    lualine_a = {
      {
        'tabs',
        use_mode_colors = true,
        mode = 1,
        max_length = vim.o.columns / 2,

        symbols = {
          -- modified = '•',
          modified = '',
        },

        fmt = function(name, context)
          -- Show • if buffer is modified in tab
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, '&mod')

          -- Get the number of windows in the tab
          local winlist = vim.fn.tabpagewinnr(context.tabnr, '$')

          -- If there is more than one window in the tab, show the number of windows in the tab
          -- if winlist > 1 then name = name .. ' [' .. winlist .. ']' end

          -- Get the names of the buffers in the windows if there is more than one window in the tab

          name = name:gsub('%..*$', '')

          if winlist > 1 then
            local buf_names = {}
            for i = 1, winlist do
              local win_bufnr = buflist[i]
              local win_bufname = vim.fn.bufname(win_bufnr):gsub('%..*$', '')
              table.insert(buf_names, vim.fn.fnamemodify(win_bufname, ':t'))
            end
            name = table.concat(buf_names, ' ┃┃ ')
          end

          return name .. (mod == 1 and ' ●' or '')
        end,
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {
      {
        'buffers',
        show_filename_only = true,
        hide_filename_extension = true,
        use_mode_colors = true,
        max_length = vim.o.columns / 2,
      },
    },
  },
  winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 4 }, { 'diagnostics' } },
    lualine_x = { { 'searchcount' }, { 'diff' } },
    lualine_y = {},
    lualine_z = {},
  },
  inactive_winbar = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 4 } },
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  sections = {
    lualine_a = { { 'mode', icons_enabled = true } },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { { repo_name }, { 'branch' } },
  },
  inactive_sections = {},
}

vim.api.nvim_set_keymap('n', '<Tab><Tab>', ':$tabnew<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Tab>d', ':tabclose<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Tab>o', ':tabonly<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Tab>]', ':tabn<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Tab>[', ':tabp<CR>', { noremap = true })

-- move current tab to previous position
vim.api.nvim_set_keymap('n', '<Tab><PageDown>', ':-tabmove<CR>', { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap('n', '<Tab><PageUp>', ':+tabmove<CR>', { noremap = true })
