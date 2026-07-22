local builtin = require 'telescope.builtin'

-- It's also possible to pass additional configuration options.
vim.keymap.set(
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  'n',
  '<leader>/',
  function()
    builtin.live_grep {
      grep_open_files = false,
      prompt_title = 'Grep',
      layout_strategy = 'horizontal',
      layout_config = {
        preview_width = 0.4,
      },
    }
  end,
  { desc = 'Srch Grep files' }
)
