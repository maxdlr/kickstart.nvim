local builtin = require 'telescope.builtin'

-- Override default behavior and theme when searching
vim.keymap.set(
  'n',
  '/',
  function()
    builtin.current_buffer_fuzzy_find {
      winblend = 5,
      virtual_lines = true,
      previewer = false,
      layout_strategy = 'vertical',
      layout_config = { prompt_position = 'top', width = 0.6, height = 0.6, mirror = true },
      sorting_strategy = 'ascending',
      mappings = {},
    }
  end,
  { desc = '[/] Fuzzily search in current buffer' }
)
