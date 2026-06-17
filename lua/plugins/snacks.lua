---@diagnostic disable: undefined-global
vim.pack.add { Gh 'folke/snacks.nvim' }
require('snacks').setup {
  dashboard = {
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
        -- { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        -- { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        -- { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        -- { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        -- { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = '🫢', key = 's', desc = 'Restore Session', action = function() require('persistence').load() end },
        { icon = '🖕', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'recent_files', padding = 1 },
    },
  },

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

  words = {
    -- your words configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },

  -- toggle = {
  --   -- your toggle configuration comes here
  --   -- or leave it empty to use the default settings
  --   -- refer to the configuration section below
  -- },

  picker = {
    sources = {
      -- gh_issue = {
      --   -- your gh_issue picker configuration comes here
      --   -- or leave it empty to use the default settings
      -- },
      gh_pr = {},
    },
  },
}

-- Snacks.lazygit():map '<leader>gg'
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'LazyGit File History' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'LazyGit Log' })

-- vim.keymap.set('n', '<leader>gp', function() Snacks.picker.gh_pr() end, { desc = 'GitHub Pull Requests (open)' })
-- vim.keymap.set('n', '<leader>gP', function() Snacks.picker.gh_pr { state = 'all' } end, { desc = 'GitHub Pull Requests (all)' })

-- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
-- { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
-- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
-- { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

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
