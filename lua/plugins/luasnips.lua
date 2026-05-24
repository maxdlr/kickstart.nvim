-- [[ Snippet Engine ]]

-- NOTE: You can also specify plugin using a version range for its git tag.
--  See `:help vim.version.range()` for more info
vim.pack.add { { src = Gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

-- `friendly-snippets` contains a variety of premade snippets.
--    See the README about individual language/framework/plugin snippets:
--    https://github.com/rafamadriz/friendly-snippets
--
-- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
-- require('luasnip.loaders.from_vscode').lazy_load()
