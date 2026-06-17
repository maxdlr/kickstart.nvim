-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files in the commands directory and load them
local commands_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'commands')
for file_name, type in vim.fs.dir(commands_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('commands.' .. module)
  end
end
