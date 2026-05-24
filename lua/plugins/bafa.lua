vim.pack.add { Gh 'mistweaverco/bafa.nvim' }
require('bafa').setup()

local options = {
  with_jump_labels = true,
}

vim.keymap.set('n', '<leader>bl', function() require('bafa').toggle(options) end, { desc = '[B]uffers [L]ist' })
vim.keymap.set('n', '<leader>bb', function() require("bafa.api").switch_to_buffer(2) end, { desc = 'Open last [B]uffer' })
