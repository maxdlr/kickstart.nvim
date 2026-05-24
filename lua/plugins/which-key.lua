-- Useful plugin to show you pending keybinds.
vim.pack.add { Gh 'folke/which-key.nvim' }
require('which-key').setup {
  preset = 'helix',
  -- Delay between pressing a key and opening which-key (milliseconds)
  delay = 500,
  icons = { mappings = vim.g.have_nerd_font },
  -- Document existing key chains
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>u', group = '[U]ser interface', mode = { 'n', 'v' } },
    { '<leader>g', group = '[G]it', mode = { 'n' } },
    { '<leader>w', group = '[W]indows', mode = { 'n' } },
    { '<leader><Tab>', group = '[Tab]s', mode = { 'n' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}
