-- Here we only install `nvim-web-devicons` (which adds pretty icons) if we have a Nerd Font,
-- since otherwise the icons won't display properly.
if vim.g.have_nerd_font then vim.pack.add { Gh 'nvim-tree/nvim-web-devicons' } end
