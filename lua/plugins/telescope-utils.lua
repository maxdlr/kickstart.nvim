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
  { label = '--- Plugins --------------------------------', action = false },
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
  { label = '--- Files --------------------------------', action = false },
  {
    icon = '',
    label = 'Copy Filename',
    action = function() vim.fn.setreg('+', vim.fn.expand '%:t:r') end,
    color = '#FFA41B',
  },
  {
    icon = '',
    label = 'Toggle CsvView',
    action = function() vim.cmd [[CsvViewToggle delimiter=; display_mode=border header_lnum=1]] end,
    color = '#FFA41B',
  },
}

vim.keymap.set('n', '<leader>$', picker('Utils', cmds, { border_color = '#D1FF1B' }))
