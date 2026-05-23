vim.pack.add { Gh 'nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    theme = 'horizon',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { { 'lsp_status', show_name = false } },
    lualine_c = { { 'filename', path = 4 }, 'diff' },
    lualine_x = { 'diagnostics', { 'filetype', icon_only = true } },
    lualine_y = { 'branch' },
    lualine_z = { 'location' },
  },
}
