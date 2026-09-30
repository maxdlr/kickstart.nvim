-- vim.pack.add {
--   Gh 'nvim-telescope/telescope.nvim',
--   { src = Gh 'maxdlr/honcho.nvim', version = 'main' },
-- }

---- Creates a Telescope dropdown picker from a list of commands.
---- @param title string Picker prompt title
---- @param commands HonchoCommandDefinition[] List of {label, action, color} pairs.
---- @param opts? {border_color?: string} border_color: optional hex color (e.g. "#7aa2f7") for the

Honcho = require 'honcho'

-- local picker = Honcho.honcho_picker

-- local separator = honcho.honcho_separator
-- local hl = vim.api.nvim_get_hl(0, { name = 'Normal' })

-- local cmds = {
--   {
--     icon = '🧪',
--     label = 'test command',
--     description = 'This is a test command',
--     action = function() print(vim.inspect 'test') end,
--   },
--
--   {
--     icon = '🦺',
--     label = 'Some other test',
--     description = 'This is a test command',
--     action = function() print(vim.inspect 'test') end,
--   },
--   {
--     label = '----------- separator -----------',
--     action = false,
--   },
--   {
--     label = 'test command',
--     description = 'This is a test command',
--     action = function() print(vim.inspect 'test') end,
--   },
-- }
--
-- local menu = picker('Testing Honcho', cmds)
--
-- vim.keymap.set('n', '<leader>o', menu, { desc = 'Honcho: Pick a task' })
