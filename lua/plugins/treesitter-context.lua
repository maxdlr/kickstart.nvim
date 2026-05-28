vim.pack.add { { src = Gh 'nvim-treesitter/nvim-treesitter-context' } }

require('treesitter-context').setup {
  max_lines = 5,
  line_numbers = true,
}

vim.keymap.set('n', '[-', function() require('treesitter-context').go_to_context() end, { desc = 'Jump to context' })
