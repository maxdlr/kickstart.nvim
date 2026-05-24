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
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>u', group = '[U]ser interface', mode = { 'n', 'v' } },
    { '<leader>g', group = '[G]it', mode = { 'n' } },
    { '<leader>w', group = '[W]indows', mode = { 'n' } },
    { '<leader>a', group = '[A]i', mode = { 'n' } },
    { '<leader>b', group = '[B]uffers', mode = { 'n' } },
    { '<leader>n', group = '[N]oices', mode = { 'n' } },
    { '<leader>q', group = 'Sessions', mode = { 'n' } },
    { '<leader>d', group = '[D]iagnostics', mode = { 'n' } },
    { '<leader>T', group = '[T]erminal', mode = { 'n' } },
    { '<leader><Tab>', group = '[Tab]s', mode = { 'n' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

vim.keymap.set('n', '<leader>?', function() require('which-key').show { global = false } end, { desc = 'Buffer Keymaps' })
