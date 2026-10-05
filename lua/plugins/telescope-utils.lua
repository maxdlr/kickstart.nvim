local picker = require('honcho').honcho_picker

local removeOrphanPlugins = function()
  local orphans = vim.iter(vim.pack.get()):filter(function(x) return not x.active end):map(function(x) return x.spec.name end):totable()

  if #orphans == 0 then
    vim.notify('No inactive plugins to remove', vim.log.levels.INFO)
    return
  end

  local choice = vim.fn.confirm(string.format('Delete %d inactive plugin(s) from disk?\n\n%s', #orphans, table.concat(orphans, '\n')), '&Yes\n&No', 2)
  if choice ~= 1 then return end

  vim.pack.del(orphans)
  vim.notify(string.format('Removed %d plugin(s): %s', #orphans, table.concat(orphans, ', ')), vim.log.levels.INFO)
end

local cmds = {
  {
    icon = '󱐥',
    label = 'Update plugins',
    action = function() vim.pack.update() end,
    color = '#D1FF1B',
  },
  {
    icon = '󱐥',
    label = 'Remove inactive plugins',
    action = removeOrphanPlugins,
    color = '#D1FF1B',
  },

  { label = '--- Files ----------------', action = false },
  {
    icon = '',
    label = 'Copy File Name',
    action = function()
      local path = vim.fn.expand '%:t:r'
      vim.fn.setreg('+', path)
      vim.notify('Copied: ' .. path, vim.log.levels.INFO)
    end,
    color = '#FFA41B',
  },
  {
    icon = '',
    label = 'Copy File Path',
    action = function()
      local path = vim.fn.expand '%'
      vim.fn.setreg('+', path)
      vim.notify('Copied: ' .. path, vim.log.levels.INFO)
    end,
    color = '#FFA41B',
  },

  { label = '--- Other ----------------', action = false },
  {
    icon = '',
    label = 'Toggle CsvView',
    action = function() vim.cmd [[CsvViewToggle delimiter=; display_mode=border header_lnum=1]] end,
    color = '#9479FF',
  },
  {
    icon = '',
    label = 'Digraphs',
    action = 'digraphs',
    color = '#9479FF',
  },
}

vim.keymap.set('n', '<leader>$', picker('Utils', cmds, { border_color = '#D1FF1B' }))
