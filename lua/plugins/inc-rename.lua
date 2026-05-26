vim.pack.add { Gh 'smjonas/inc-rename.nvim' }
require('inc_rename').setup { input_buffer_type = 'snacks' }
vim.keymap.set('n', '<leader>cr', ':IncRename', { desc = 'Rename symbol' })
