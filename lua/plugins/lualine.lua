vim.pack.add { Gh 'nvim-lualine/lualine.nvim' }

-- Start from the built-in horizon theme and override the `a` section colors
-- (per-mode) instead of using the theme's defaults.
local horizon = require 'lualine.themes.horizon'
local theme = vim.deepcopy(horizon)

for _, mode in ipairs {
  'normal',
  -- 'insert', 'visual', 'replace', 'command', 'terminal', 'inactive'
} do
  if theme[mode] and theme[mode].a then theme[mode].a.bg = '#FF0055' end

  if theme[mode] and theme[mode].c then theme[mode].c.fg = '#FF0055' end
  if theme[mode] and theme[mode].c then theme.inactive.a.bg = '#2E303E' end
  if theme[mode] and theme[mode].c then theme.inactive.a.fg = '#FF0055' end
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
    always_show_tabline = false,
  },
  extensions = { 'quickfix', 'fzf', 'neo-tree', 'toggleterm', 'trouble' },
  tabline = {
    lualine_a = { { 'tabs' } },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { { 'buffers' } },
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
