local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'

vim.keymap.set('n', '<leader>TL', function()
  local terms = require('toggleterm.terminal').get_all(true)
  if #terms == 0 then
    vim.notify('No toggleterm terminals', vim.log.levels.INFO)
    return
  end

  pickers.new(require('telescope.themes').get_dropdown {
    winblend = 5,
    layout_strategy = 'horizontal',
    layout_config = { prompt_position = 'top', width = 0.6, height = 0.6 },
    previewer = true,
    sorting_strategy = 'ascending',
  }, {
    prompt_title = 'Terminals',
    finder = finders.new_table {
      results = terms,
      entry_maker = function(term)
        local name = term.name or ('Terminal #' .. term.id)
        local dir = term.dir or ''
        return {
          value = term,
          display = string.format('#%d %s [%s] %s', term.id, name, term.direction, dir),
          ordinal = name .. ' ' .. dir,
          bufnr = term.bufnr,
        }
      end,
    },
    sorter = conf.generic_sorter {},
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local term = entry.value
        if term:is_open() then
          term:focus()
        else
          term:toggle()
        end
      end)
      return true
    end,
  }):find()
end, { desc = 'List terminals' })
