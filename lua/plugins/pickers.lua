vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.smart() end, { desc = 'Srch Files' })

vim.keymap.set('n', '<leader>.', function() Snacks.picker.recent() end, { desc = 'Buffers (active)' })

vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Srch Grep files' })
