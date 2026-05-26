-- keymap to delete buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>bo', ':bufdo bdelete<CR>', { desc = 'Delete all other buffers' })
