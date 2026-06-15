vim.o.number = true
vim.o.relativenumber = true

-- Show which line your cursor is on
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 4

vim.keymap.set({ 'n', 'x' }, '<PageDown>', '5j', { desc = 'Scroll down 5 lines' })
vim.keymap.set('i', '<PageDown>', '<C-o>5j', { desc = 'Scroll down 5 lines' })
vim.keymap.set({ 'n', 'x' }, '<PageUp>', '5k', { desc = 'Scroll up 5 lines' })
vim.keymap.set('i', '<PageUp>', '<C-o>5k', { desc = 'Scroll up 5 lines' })

