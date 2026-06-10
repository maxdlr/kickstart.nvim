vim.pack.add { Gh 'MagicDuck/grug-far.nvim' }
require('grug-far').setup {
  headerMaxWidth = 60,
  keymaps = {
    close = { n = 'q' },
  },
}

vim.keymap.set('n', '<leader>sr', function()
  local grug = require 'grug-far'
  local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
  grug.open {
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  }
end, { desc = 'Search and Replace' })
