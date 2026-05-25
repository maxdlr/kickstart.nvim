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
    { '<leader>s', group = ' Search', mode = { 'n', 'v' } },
    { '<leader>u', group = ' User interface', mode = { 'n', 'v' } },
    { '<leader>g', group = ' Git', mode = { 'n' } },
    { '<leader>w', group = ' Windows', mode = { 'n' } },
    { '<leader>a', group = ' Ai', mode = { 'n' } },
    { '<leader>c', group = ' Code', mode = { 'n', 'v' } },
    { '<leader>b', group = ' Buffers', mode = { 'n' } },
    { '<leader>n', group = ' Noices', mode = { 'n' } },
    { '<leader>q', group = ' Sessions', mode = { 'n' } },
    { '<leader>d', group = ' Diagnostics', mode = { 'n' } },
    { '<leader>T', group = ' Terminal', mode = { 'n' } },
    { '<leader><Tab>', group = ' Tabs', mode = { 'n' } },
    { 'gr', group = ' LSP Actions', mode = { 'n' } },
  },
}

vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = false } end, { desc = 'Buffer Keymaps' })
