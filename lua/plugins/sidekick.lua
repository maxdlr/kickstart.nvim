vim.pack.add { Gh 'folke/sidekick.nvim' }
require('sidekick').setup {
  cli = {
    win = {
      layout = 'right',
      float = { width = 0.9, height = 0.9 },
      split = { width = 80, height = 20 },
    },
    tools = {
      kiro = {
        cmd = { 'kiro-cli' },
        is_proc = '\\<kiro\\>',
        url = 'https://kiro.dev',
      },
    },
    mux = {
      backend = 'tmux',
      enabled = true,
    },
  },
}

local map = vim.keymap.set

map('n', '<M-h>', function() require('sidekick').nes_jump_or_apply() end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })
map('n', '<leader>ae', function() require('sidekick.nes').toggle() end, { desc = 'Toggle Next Edit Suggestions' })
map('n', '<leader>au', function() require('sidekick').update() end, { expr = true, desc = 'Update Next Edit Suggestion' })
map('n', '<leader>aa', function() require('sidekick.cli').toggle() end, { desc = 'Sidekick Toggle CLI' })
map('n', '<leader>as', function() require('sidekick.cli').select() end, { desc = 'Select CLI' })
map('n', '<leader>ad', function() require('sidekick.cli').close() end, { desc = 'Detach a CLI Session' })
map({ 'x', 'n' }, '<leader>at', function() require('sidekick.cli').send { msg = '{this}' } end, { desc = 'Send This' })
map('n', '<leader>af', function() require('sidekick.cli').send { msg = '{file}' } end, { desc = 'Send File' })
map('x', '<leader>av', function() require('sidekick.cli').send { msg = '{selection}' } end, { desc = 'Send Visual Selection' })
map({ 'n', 'x' }, '<leader>ap', function() require('sidekick.cli').prompt() end, { desc = 'Sidekick Select Prompt' })
map('n', '<leader>ac', function() require('sidekick.cli').toggle { name = 'copilot', focus = true } end, { desc = 'Sidekick Toggle Copilot' })
map('n', '<leader>ak', function() require('sidekick.cli').toggle { name = 'kiro', focus = true } end, { desc = 'Sidekick Toggle Kiro' })
