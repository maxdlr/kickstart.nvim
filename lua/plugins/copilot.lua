vim.pack.add { Gh 'zbirenbaum/copilot.lua' }
require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    hide_during_completion = false,
    keymap = {
      accept = 'Ì',
      accept_word = '¬',
      -- accept_line = '€',
      -- next = 'Ï',
      -- prev = 'È',
      -- dismiss = '∂',
    },
  },
  panel = { enabled = false },
}
