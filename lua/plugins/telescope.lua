-- [[ Fuzzy Finder (files, lsp, etc) ]]
--
-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
-- so feel free to experiment and see what you like!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

---@type (string|vim.pack.Spec)[]
local telescope_plugins = {
  Gh 'nvim-lua/plenary.nvim',
  Gh 'nvim-telescope/telescope.nvim',
  Gh 'nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, Gh 'nvim-telescope/telescope-fzf-native.nvim') end

-- NOTE: You can install multiple plugins at once
vim.pack.add(telescope_plugins)

local focus_preview = function(prompt_bufnr)
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local action_layout = require('telescope.actions.layout')
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win

  -- If previewer is hidden, toggle it on first
  if not picker.previewer then
    action_layout.toggle_preview(prompt_bufnr)
    picker = action_state.get_current_picker(prompt_bufnr)
  end

  local previewer = picker.previewer
  if not previewer or not previewer.state then return end
  local winid = previewer.state.winid
  local bufnr = previewer.state.bufnr

  vim.keymap.set('n', '<Tab>', function() vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', prompt_win)) end, { buffer = bufnr })
  vim.keymap.set('n', '<Esc>', function() actions.close(prompt_bufnr) end, { buffer = bufnr })
  vim.keymap.set('n', '<CR>', function() actions.file_edit(prompt_bufnr) end, { buffer = bufnr })

  vim.cmd(string.format('noautocmd lua vim.api.nvim_set_current_win(%s)', winid))
end

-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
   n = {
      ['<Tab>'] = focus_preview,
      ['<C-P>'] = require('telescope.actions.layout').toggle_preview,
      ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
      ['<C-Down>'] = require('telescope.actions').cycle_history_next,
    },
    i = {
      ['<Tab>'] = focus_preview,
      ['<c-enter>'] = 'to_fuzzy_refine',
      ['<C-P>'] = require('telescope.actions.layout').toggle_preview,
      ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
      ['<C-Down>'] = require('telescope.actions').cycle_history_next,
    },
    },
  },
  -- pickers = {}
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopePreviewerLoaded',
  callback = function()
    vim.wo.number = true
    vim.o.relativenumber = true
    vim.o.wrap = true
  end,
})

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')
pcall(require('telescope').load_extension, 'yank_history')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Select Telescope' })
vim.keymap.set('n', '<leader>sR', builtin.resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>s:', builtin.commands, { desc = 'Commands' })

vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Srch Files' })

vim.keymap.set('n', '<leader>cD', builtin.diagnostics, { desc = 'Diagnostics' })

vim.keymap.set('n', '<leader>uC', function() builtin.colorscheme({ enable_preview = true, ignore_builtins = true }) end, { desc = 'Colorscheme' })

-- Add Telescope-based LSP pickers when an LSP attaches to a buffer.
-- If you later switch picker plugins, this is where to update these mappings.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client or not client:supports_method('textDocument/references', event.buf) then return end

    local buf = event.buf

    -- Find references for the word under your cursor.
    vim.keymap.set('n', 'gr', builtin.lsp_references, { buffer = buf, desc = 'References' })
    vim.keymap.set('n', 'gR', function () builtin.lsp_references { jump_type ='vsplit' } end, { buffer = buf, desc = 'References' })

    -- Jump to the implementation of the word under your cursor.
    -- Useful when your language has ways of declaring types without an actual implementation.
    vim.keymap.set('n', '<leader>ci', builtin.lsp_implementations, { buffer = buf, desc = 'Implementation' })

  -- vim.keymap.set('n', '<leader>cm', '<cmd>TSToolsAddMissingImports<cr>', { buffer = buf, desc = 'Add missing imports' })

    -- Jump to the definition of the word under your cursor.
    -- This is where a variable was first declared, or where a function is defined, etc.
    -- To jump back, press <C-t>.
    vim.keymap.set('n', 'gd', builtin.lsp_definitions, { buffer = buf, desc = 'Definition' })
    vim.keymap.set('n', 'gD', function() builtin.lsp_definitions { jump_type = 'vsplit' } end, { buffer = buf, desc = 'Definition (split)' })

    -- Fuzzy find all the symbols in your current document.
    -- Symbols are things like variables, functions, types, etc.
    vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, { buffer = buf, desc = 'Symbols' })

    -- Fuzzy find all the symbols in your current workspace.
    -- Similar to document symbols, except searches over your entire project.
    -- vim.keymap.set('n', 'gW', builtin.lsp_dynamic_workspace_symbols, { buffer = buf, desc = 'Open Workspace Symbols' })

    -- Jump to the type of the word under your cursor.
    -- Useful when you're not sure what type a variable is and you want to see
    -- the definition of its *type*, not where it was *defined*.
    vim.keymap.set('n', '<leader>ct', builtin.lsp_type_definitions, { buffer = buf, desc = 'Type' })
  end,
})





-- Shortcut for searching your Neovim configuration files
vim.keymap.set('n', '<leader>sc', function() builtin.find_files { cwd = vim.fn.stdpath 'config' } end, { desc = ' Nvim [C]onfiguration files' })
vim.keymap.set('n', '<leader>\\', builtin.grep_string, { desc = 'Srch under cursor' })
