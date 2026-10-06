---@diagnostic disable: undefined-global
vim.pack.add { Gh 'folke/snacks.nvim' }

local dashboard = {
  preset = {
    header = [[
     ___          ___          __
    /  /\        /  /\        |  |\
   /  /::|      /  /::\       |  |:|
  /  /:|:|     /  /:/\:\      |  |:|
 /  /:/|:|__  /  /::\ \:\     |__|:|__
/__/:/_|::::\/__/:/\:\_\:\____/__/::::\
\__\/  /~~/:/\__\/  \:\/:/\__\::::/~~~~
      /  /:/      \__\::/    |~~|:|
     /  /:/       /  /:/     |  |:|
    /__/:/       /__/:/      |__|:|
    \__\/        \__\/        \__\|
]],
    keys = {
      { icon = '🫢', key = 's', desc = 'Restore Session', action = function() require('persistence').load() end },
      { icon = '🖕', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
  sections = {
    { section = 'header' },
    { section = 'keys', gap = 1, padding = 1 },
    -- { section = 'recent_files', padding = 1 },
  },
}

require('snacks').setup {
  dashboard = dashboard,

  explorer = {
    win = { list = { wo = { number = true } } },
  },

  zen = {
    toggles = {
      dim = false,
      git_signs = true,
      mini_diff_signs = true,
      width = '',
    },
    win = {
      width = 160,
    },
  },

  statuscolumn = {},

  gh = {},

  words = {},

  -- toggle = {
  -- },

  picker = {
    layout = {
      layout = {},
    },
    sources = {
      -- gh_issue = {},
      gh_pr = {
        sort = { fields = { 'score:desc', 'idx' } },
      },
    },
  },

  image = {},
  indent = {},
}

-- Snacks.lazygit():map '<leader>gg'
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'LazyGit File History' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'LazyGit Log' })
vim.keymap.set('n', '<leader>g<leader>', function() Snacks.picker.git_files() end, { desc = 'LazyGit Log' })

Snacks.toggle.zoom():map('<leader>wm'):map '<leader>uZ'
Snacks.toggle.zen():map '<leader>uz'

-- Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.diagnostics():map '<leader>ud'

Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'

Snacks.toggle.dim():map '<leader>uD'

Snacks.toggle.inlay_hints():map '<leader>uh'
Snacks.toggle.indent():map '<leader>ug'

Snacks.toggle
  .new({
    name = 'Auto Save',
    get = function() return require('auto-save').enabled() end,
    set = function(state)
      if state then
        require('auto-save').on()
      else
        require('auto-save').off()
      end
    end,
  })
  :map '<leader>ua'

vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename symbol' })

vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '\\', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
vim.keymap.set('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
-- Snacks.toggle.treesitter():map '<leader>uT'
-- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
