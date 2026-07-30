vim.pack.add { Gh 'stevearc/dressing.nvim' }
vim.pack.add { Gh 'vi013t/easycolor.nvim' }

require('easycolor').setup {
  -- Optional, but provides better UI for editing the formatting template
  dressing = true,
  -- Optional, but provides better UI for picking colors
  telescope = true,
  -- Optional, but provides better UI for picking colors
  fzf = true,
}

vim.keymap.set('n', '<leader>sc', '<cmd>EasyColor<cr>', { desc = 'Color Picker' })
