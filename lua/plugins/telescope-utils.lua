local my_commands = {
  { '󰐥 Restart', function() vim.cmd [[restart]] end },
  { '󰚰 Update plugins', function() vim.pack.update() end },
  { ' Toggle CsvView', function() vim.cmd [[CsvViewToggle delimiter=; display_mode=border header_lnum=1]] end },
  { ' Copy Filename', function() vim.fn.setreg('+', vim.fn.expand '%:t:r') end },
}

vim.keymap.set('n', '<leader>$', Command_picker('Utils', my_commands), { desc = 'Personal commands' })
