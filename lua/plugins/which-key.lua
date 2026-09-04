-- Useful plugin to show you pending keybinds.
vim.pack.add { Gh 'folke/which-key.nvim' }
require('which-key').setup {
  preset = 'helix',
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 100,
  sort = { 'desc' },
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    mode = { 'n', 'x' },
    { '<leader>a', icon = '', group = ' Ai', mode = { 'n' } },
    { '<leader>b', group = ' Buffers', mode = { 'n' } },
    { '<leader>c', group = ' Code', mode = { 'n', 'v' } },
    { '<leader>d', group = ' Debug', mode = { 'n' } },

    { '<leader>e', icon = { icon = '', color = 'orange' } },
    { '<leader>E', icon = { icon = '', color = 'orange' } },

    { '<leader>g', group = ' Git', mode = { 'n' } },
    { '<leader>h', icon = '󰾹', group = ' Macros', mode = { 'n' } },
    { '<leader>m', icon = '󱘈', group = ' Markers', mode = { 'n' } },
    { '<leader>n', group = ' Noices', mode = { 'n' } },
    { '<leader>p', icon = { icon = '', color = 'yellow' } },
    { '<leader>q', group = ' Sessions', mode = { 'n' } },
    { '<leader>r', icon = { icon = '󱐫', color = 'red' }, group = ' Airtable', mode = { 'n' } },
    { '<leader>s', group = ' Search', mode = { 'n', 'v' } },
    { '<leader>sr', group = ' Search and replace', mode = { 'n', 'v' } },
    { '<leader>T', group = ' Terminal', mode = { 'n' } },
    { '<leader>u', icon = '󱠏', group = ' User interface', mode = { 'n', 'v' } },
    { '<leader>w', group = ' Windows', mode = { 'n' } },
    { '<leader>x', group = ' Diagnostics', mode = { 'n' } },

    { '<Tab>', group = ' Tabs', mode = { 'n' } },

    { '<leader>$', icon = '', group = ' Utils' },

    { '<leader><leader>', icon = { icon = '', color = 'blue' } },
    { '<leader>/', icon = { icon = '', color = 'blue' } },
    { '<leader>\\', icon = { icon = '', color = 'blue' } },

    { '<leader>|', icon = { icon = '', color = 'green' } },
    { '<leader>-', icon = { icon = '', color = 'green' } },

    -- { 'gr', group = ' LSP Actions', mode = { 'n' } },
  },
}

vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = true } end, { desc = 'Buffer Keymaps' })
