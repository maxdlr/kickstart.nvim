local my_commands = {
  { 'Restart', function() vim.cmd [[restart]] end },
  { 'Update plugins', function() vim.pack.update() end },
  { 'Toggle CsvView', 'CsvViewToggle delimiter=; display_mode=border header_lnum=1' },
}

vim.keymap.set('n', '<leader>$', Command_picker('Utils', my_commands), { desc = 'Personal commands' })
