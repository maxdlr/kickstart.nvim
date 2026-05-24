vim.pack.add { Gh 'nanozuki/tabby.nvim' }
require("tabby").setup()

vim.api.nvim_set_keymap("n", "<leader><Tab><Tab>", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>d", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>o", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>]", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>[", ":tabp<CR>", { noremap = true })

-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader><Tab><PageDown>", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader><Tab><PageUp>", ":+tabmove<CR>", { noremap = true })
