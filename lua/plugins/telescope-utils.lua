local my_commands = {
  { '󰐥 Restart', function() vim.cmd [[restart]] end, '#FF6B6B' },
  { '󰚰 Update plugins', function() vim.pack.update() end, '#FFA41B' },
  { ' Toggle CsvView', function() vim.cmd [[CsvViewToggle delimiter=; display_mode=border header_lnum=1]] end, '#1B9FFF' },
  { ' Copy Filename', function() vim.fn.setreg('+', vim.fn.expand '%:t:r') end, '#D1FF1B' },
}

vim.keymap.set('n', '<leader>$', Command_picker('Utils', my_commands, { border_color = '#D1FF1B' }), { desc = 'Personal commands' })
