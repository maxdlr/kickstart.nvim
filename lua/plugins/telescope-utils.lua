-- Curated personal commands: { label, action }
-- action is a string (Ex/<cmd> command) or a Lua function.
local my_commands = {
  {
    'Reload config',
    function()
      for name in pairs(package.loaded) do
        if name:match '^plugins' or name:match '^keymaps' or name:match '^ui' then package.loaded[name] = nil end
      end
      vim.cmd 'source $MYVIMRC'
    end,
  },
  { 'Update plugins', function() vim.pack.update() end },
  { 'Toggle CsvView', '<Cmd>CsvViewToggle delimiter=; display_mode=border header_lnum=1<CR>' },
}

vim.keymap.set('n', '<leader>$', function()
  require('telescope.pickers')
    .new(require('telescope.themes').get_dropdown {}, {
      prompt_title = 'Personal Commands',
      finder = require('telescope.finders').new_table {
        results = my_commands,
        entry_maker = function(e) return { value = e, display = e[1], ordinal = e[1] } end,
      },
      sorter = require('telescope.config').values.generic_sorter {},
      attach_mappings = function(bufnr)
        require('telescope.actions').select_default:replace(function()
          require('telescope.actions').close(bufnr)
          local action = require('telescope.actions.state').get_selected_entry().value[2]
          if type(action) == 'function' then
            action()
          else
            vim.cmd(vim.keycode(action))
          end
        end)
        return true
      end,
    })
    :find()
end, { desc = 'Personal commands' })
