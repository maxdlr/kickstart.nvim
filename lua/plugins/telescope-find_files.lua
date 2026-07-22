local builtin = require 'telescope.builtin'

vim.keymap.set(
  'n',
  '<leader><leader>',
  function()
    builtin.find_files {
      layout_strategy = 'vertical',
      layout_config = { width = 0.6 },
      preview_height = 0.3,
    }
  end,
  { desc = 'Srch Files' }
)
