vim.pack.add { Gh 'zbirenbaum/copilot.lua' }
require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    hide_during_completion = false,
    keymap = {
      accept = 'Ì',
      accept_word = '<C-l>',
      accept_line = '<C-$>',
      next = '<C-j>',
      prev = '<C-k>',
      dismiss = '<C-d>',
    },
  },
  panel = { enabled = false },
}
