vim.o.number = true
vim.o.relativenumber = true

-- Show which line your cursor is on
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 5

vim.keymap.set('n', '<leader>ul', function()
  if vim.o.number == true or vim.o.relativenumber == true then
    vim.o.number = false
    vim.o.relativenumber = false
  else
    vim.o.number = true
    vim.o.relativenumber = true
  end
end, { desc = 'Toggle line number' })
