vim.pack.add { Gh 'chrisgrieser/nvim-spider' }
require('spider').setup {
  skipInsignificantPunctuation = true,
  subwordMovement = true,
  consistentOperatorPending = false, -- see the README for details
  customPatterns = {}, -- see the README for details
}

vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>")
vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>")

