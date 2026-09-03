local my_commands = {
  { '󰐥 Restart', function() vim.cmd [[restart]] end, '#FF6B6B' },
  { '󰚰 Update plugins', function() vim.pack.update() end, '#FFA41B' },
  { ' Toggle CsvView', function() vim.cmd [[CsvViewToggle delimiter=; display_mode=border header_lnum=1]] end, '#1B9FFF' },
  { ' Copy Filename', function() vim.fn.setreg('+', vim.fn.expand '%:t:r') end, '#D1FF1B' },
  {
    ' Remove inactive plugins',
    function()
      local orphans = vim.iter(vim.pack.get()):filter(function(x) return not x.active end):map(function(x) return x.spec.name end):totable()

      if #orphans == 0 then
        vim.notify('No inactive plugins to remove', vim.log.levels.INFO)
        return
      end

      local choice =
        vim.fn.confirm(string.format('Delete %d inactive plugin(s) from disk?\n\n%s', #orphans, table.concat(orphans, '\n')), '&Yes\n&No', 2)
      if choice ~= 1 then return end

      vim.pack.del(orphans)
      vim.notify(string.format('Removed %d plugin(s): %s', #orphans, table.concat(orphans, ', ')), vim.log.levels.INFO)
    end,
    '#FF6B6B',
  },
}

vim.keymap.set('n', '<leader>$', Command_picker('Utils', my_commands, { border_color = '#D1FF1B' }), { desc = 'Personal commands' })
