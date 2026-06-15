local builtin = require 'telescope.builtin'
-- local actions = require 'telescope.actions'
-- local action_state = require 'telescope.actions.state'

vim.keymap.set('n', '/', function()
  builtin.current_buffer_fuzzy_find {
    winblend = 5,
    virtual_lines = true,
    previewer = false,
    layout_strategy = 'vertical',
    skip_empty_lines = true,
    layout_config = { prompt_position = 'top', width = 0.6, height = 0.6, mirror = true },
    sorting_strategy = 'ascending',
    -- attach_mappings = function(_, map)
    --   map({ 'n', 'i', 'x' }, '<CR>', function(prompt_bufnr)
    --     local prompt = action_state.get_current_picker(prompt_bufnr):_get_prompt()
    --     vim.fn.setreg('/', prompt)
    --     vim.opt.hlsearch = true
    --     actions.select_default(prompt_bufnr)
    --   end)
    --   return true
    -- end,
  }
end, { desc = '[/] Fuzzily search in current buffer' })
