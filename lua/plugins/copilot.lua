vim.pack.add { Gh 'zbirenbaum/copilot.lua' }
require('copilot').setup {
  -- requires = {
  --   "copilotlsp-nvim/copilot-lsp",
  --   init = function()
  --     vim.g.copilot_nes_debounce = 500
  --   end,
  -- },
  event = { 'InsertEnter' },
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        hide_during_completion = false, -- <--- ADD THIS
        keymap = {
          accept = '<C-h>', -- Accept suggestion
          accept_word = '<C-l>', -- Accept suggestion word by word
          accept_line = '<C-$>', -- Accept suggestion line by line
          next = '<C-j>', -- Next suggestion
          prev = '<C-k>', -- Previous suggestion
          dismiss = '<C-d>', -- Dismiss suggestion
        },
      },
      panel = { enabled = false },
      -- nes = {
      --   enabled = true,
      --   keymap = {
      --     accept_and_goto = "<leader>ap",
      --     accept = false,
      --     dismiss = "<Esc>",
      --   },
      -- },
    }
  end,
}
