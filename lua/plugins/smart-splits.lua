vim.pack.add {
  Gh 'smart-splits-nvim/smart-splits.nvim',
  Gh 'smart-splits-nvim/backend-wezterm',
}

local ss = require 'smart-splits'

ss.setup {
  resize = {
    amount = 3,
  },
  move = {
    at_edge = 'stop',
  },
  mux = {
    backend = 'smart-splits-backend-wezterm',
  },
}

vim.keymap.set('n', '<C-h>', ss.move_cursor_left, { desc = 'Move focus to the left window/pane' })
vim.keymap.set('n', '<C-j>', ss.move_cursor_down, { desc = 'Move focus to the lower window/pane' })
vim.keymap.set('n', '<C-k>', ss.move_cursor_up, { desc = 'Move focus to the upper window/pane' })
vim.keymap.set('n', '<C-l>', ss.move_cursor_right, { desc = 'Move focus to the right window/pane' })

vim.keymap.set('n', '<C-a-h>', ss.resize_left, { desc = 'Move focus to the left window/pane' })
vim.keymap.set('n', '<C-a-l>', ss.resize_right, { desc = 'Move focus to the left window/pane' })

vim.keymap.set('n', '<leader>wh', ss.swap_buf_left, { desc = 'Move window to far left' })
vim.keymap.set('n', '<leader>wl', ss.swap_buf_right, { desc = 'Move window to far right' })
vim.keymap.set('n', '<leader>wj', ss.swap_buf_down, { desc = 'Move window to far bottom' })
vim.keymap.set('n', '<leader>wk', ss.swap_buf_up, { desc = 'Move window to far top' })
-- vim.keymap.set('n', '<leader>w<Tab>', '<C-w>x', { desc = 'Switch current with next' })
