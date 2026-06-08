-- [[ Formatting ]]
vim.pack.add { Gh 'stevearc/conform.nvim' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable for filetypes you don't want to autoformat
    local disabled_filetypes = {}
    if disabled_filetypes[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 500 }
  end,
  default_format_opts = {
    lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
  },
  formatters_by_ft = {
    javascript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    json = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    css = { 'prettierd', 'prettier', stop_after_first = true },
  },
  formatters = {
    biome = {
      condition = function() return vim.fs.find({ 'biome.json', 'biome.jsonc' }, { upward = true, type = 'file' })[1] ~= nil end,
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>cf', function() require('conform').format { async = true } end, { desc = 'Format buffer' })
