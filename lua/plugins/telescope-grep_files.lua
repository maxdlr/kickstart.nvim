local builtin = require 'telescope.builtin'
local telescope_entry_maker = require 'plugins.telescope-entry-maker'

-- It's also possible to pass additional configuration options.
vim.keymap.set(
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  'n',
  '<leader>/',
  function()
    builtin.live_grep {
      entry_maker = telescope_entry_maker.grep_entry_maker { cwd = vim.uv.cwd() },
      grep_open_files = false,
      prompt_title = 'Grep',
      layout_strategy = 'vertical',
      layout_config = {
        preview_height = 0.3,
      },
    }
  end,
  { desc = 'Srch Grep files' }
)
