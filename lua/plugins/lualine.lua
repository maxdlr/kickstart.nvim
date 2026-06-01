vim.pack.add { Gh 'nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = {
    theme = 'horizon',
    globalstatus = true,
  },
  sections = {
    lualine_a = { 'mode' },
    -- lualine_b = { { 'lsp_status', show_name = false } },
    lualine_b = { { 'filename', path = 4 } },
    lualine_c = { 'diagnostics', { 'filetype', icon_only = true }, 'branch', 'diff' },
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'buffers' },
  },
}
