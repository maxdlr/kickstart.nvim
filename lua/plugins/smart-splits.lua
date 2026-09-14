vim.pack.add { Gh 'mrjones2014/smart-splits.nvim' }

require('smart-splits').setup {
  default_amount = 3,
  at_edge = 'stop',
  multiplexer_integration = 'wezterm',
}

vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left, { desc = 'Move focus to the left window/pane' })
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down, { desc = 'Move focus to the lower window/pane' })
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up, { desc = 'Move focus to the upper window/pane' })
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right, { desc = 'Move focus to the right window/pane' })
