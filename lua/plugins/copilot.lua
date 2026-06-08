vim.pack.add { Gh 'zbirenbaum/copilot.lua' }
require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    hide_during_completion = false,
    keymap = {
      accept = '<M-h>',
      accept_word = '<M-l>',
      accept_line = '<M-$>',
      next = '<M-j>',
      prev = '<M-k>',
      dismiss = '<M-d>',
    },
  },
  panel = { enabled = false },
}
