local builtin = require 'telescope.builtin'
local telescope_entry_maker = require 'plugins.telescope-entry-maker'

vim.keymap.set(
  'n',
  '<leader><leader>',
  function()
    builtin.find_files {
      layout_strategy = 'vertical',
      layout_config = { width = 0.6 },
      preview_height = 0.3,
      entry_maker = telescope_entry_maker.file_entry_maker(),
    }
  end,
  { desc = 'Srch Files' }
)
