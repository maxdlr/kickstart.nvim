vim.pack.add { Gh 'stevearc/dressing.nvim' }
vim.pack.add { Gh 'neph-iap/easycolor.nvim' }

require('easycolor').setup {
  -- Optional, but provides better UI for editing the formatting template
  dressing = true,
  -- Optional, but provides better UI for picking colors
  telescope = true,
  -- Optional, but provides better UI for picking colors
  fzf = true,
}

-- return {
--   'neph-iap/easycolor.nvim',
--   dependencies = { 'stevearc/dressing.nvim' }, -- Optional, but provides better UI for editing the formatting template
--   opts = {},
--   keys = { { '<leader>uP', '<cmd>EasyColor<cr>', desc = 'Color Picker' } },
-- }

vim.keymap.set('n', '<leader>uP', '<cmd>EasyColor<cr>', { desc = 'Color Picker' })
