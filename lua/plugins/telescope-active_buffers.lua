local builtin = require 'telescope.builtin'

vim.keymap.set(
  'n',
  '<leader>,',
  function()
    builtin.buffers(require('telescope.themes').get_dropdown {
      winblend = 5,
      virtual_lines = true,
      layout_strategy = 'vertical',
      layout_config = { prompt_position = 'top', width = 0.6, height = 0.6 },
      previewer = true,
      sorting_strategy = 'ascending',
    })
  end,
  { desc = 'Buffers (active)' }
)
