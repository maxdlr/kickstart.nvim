-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Splits
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<CR>', { desc = 'Split Vertical' })
vim.keymap.set('n', '<leader>-', '<cmd>split<CR>', { desc = 'Split horizontal' })

-- Closing
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = 'Close all other windows' })

-- Moving
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move window to far left' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move window to far right' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move window to far bottom' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move window to far top' })
vim.keymap.set('n', '<leader>w<Tab>', '<C-w>x', { desc = 'Switch current with next' })
vim.keymap.set('n', '<leader>wt', '<C-w>t', { desc = 'Into a new tab' })

-- resizing
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equal widths and heights' })
