vim.pack.add {
  Gh 'nvim-telescope/telescope.nvim',
  { src = Gh 'maxdlr/honcho.nvim', version = 'main' },
}

local honcho = require 'honcho'
local picker = honcho.honcho_picker

-- local separator = honcho.honcho_separator
local hl = vim.api.nvim_get_hl(0, { name = 'Normal' })

local cmds = {
  {
    label = 'test command',
    description = 'This is a test command',
    action = function() print(vim.inspect 'test') end,
  },
  {
    label = '----------- separator -----------',
    action = false,
  },
}

vim.keymap.set('n', '<leader>o', picker('Honcho test', cmds), { desc = 'Honcho: Pick a task' })
