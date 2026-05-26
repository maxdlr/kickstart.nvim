vim.pack.add { Gh 'gbprod/yanky.nvim' }
require('yanky').setup {
  preserve_cursor_position = {
    enabled = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 300,
  },
}

vim.keymap.set({ 'n', 'x' }, 'y', '<Plug>(YankyYank)')
