vim.pack.add { Gh 'brenoprata10/nvim-highlight-colors' }

require('nvim-highlight-colors').setup {
  render = 'background', -- 'background' | 'foreground' | 'virtual'
  enable_tailwind = true,
}
