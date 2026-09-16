-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files plugouts commands directory and load them
local plugouts_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugouts')
for file_name, type in vim.fs.dir(plugouts_dir) do
  if type == 'file' and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('plugouts.' .. module)
  end
end
