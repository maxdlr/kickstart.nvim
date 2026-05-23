-- Highlight todo, notes, etc in comments
vim.pack.add { Gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }
