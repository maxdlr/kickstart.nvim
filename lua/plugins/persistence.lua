vim.pack.add { Gh 'folke/persistence.nvim' }
require('persistence').setup()

local map = vim.keymap
map.set('n', '<leader>qs', function() require('persistence').load() end, { desc = 'Restore Session' })
map.set('n', '<leader>qS', function() require('persistence').select() end, { desc = 'Select Session' })
map.set('n', '<leader>ql', function() require('persistence').load { last = true } end, { desc = 'Restore Last Session' })
map.set('n', '<leader>qd', function() require('persistence').stop() end, { desc = "Don't Save Current Session" })
map.set('n', '<leader>qq', "<Cmd>wqa!<CR>", { desc = "[W]rite [a]ll and [Q]uit Neovim" })
