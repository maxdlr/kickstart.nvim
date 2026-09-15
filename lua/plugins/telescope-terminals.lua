local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local previewers = require 'telescope.previewers'

local terminal_previewer = previewers.new_buffer_previewer {
  title = 'Shell Preview',
  define_preview = function(self, entry)
    local term = entry.value
    if not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { 'Terminal is not running.' })
      return
    end
    local lines = vim.api.nvim_buf_get_lines(term.bufnr, 0, -1, false)
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
  end,
}

local function list_terminals()
  local terms = require('toggleterm.terminal').get_all(true)
  if #terms == 0 then
    vim.notify('No toggleterm terminals', vim.log.levels.INFO)
    return
  end

  local function make_finder()
    return finders.new_table {
      results = require('toggleterm.terminal').get_all(true),
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
    }
  end

  local picker = pickers.new(
    require('telescope.themes').get_dropdown {
      winblend = 5,
      layout_strategy = 'horizontal',
      layout_config = { prompt_position = 'top', width = 0.6, height = 0.6 },
      previewer = false,
      sorting_strategy = 'ascending',
    },
    {
      prompt_title = 'Terminals',
      finder = make_finder(),
      sorter = conf.generic_sorter {},
      previewer = terminal_previewer,
      attach_mappings = function(prompt_bufnr, map)
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

        map('n', 'x', function()
          local entry = action_state.get_selected_entry()
          if not entry then return end
          entry.value:shutdown()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:refresh(make_finder(), { reset_prompt = false })
        end)

        return true
      end,
    }
  )
  picker:find()
end

vim.keymap.set('n', '<leader>tl', list_terminals, { desc = 'List' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'toggleterm',
  callback = function(args) vim.keymap.set('n', '<Tab>', list_terminals, { buffer = args.buf, desc = 'List' }) end,
})
