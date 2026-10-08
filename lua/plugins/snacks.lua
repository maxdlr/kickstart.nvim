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
    list = {
      keys = {
        ['<C-p>'] = 'focus_preview',
      },
    },
    -- win = {
    --   list = {
    --     keys = {
    --       ['<C-p>'] = 'focus_preview',
    --     },
    --   },
    -- },
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
    win = {
      -- result list window
      list = {
        wo = { number = true, relativenumber = true },
        keys = {
          ['<C-l>'] = 'focus_preview',
        },
      },

      preview = {
        wo = { number = true, relativenumber = true },
        keys = {
          ['<C-h>'] = 'focus_input',
          ['<Esc>'] = 'close',
        },
      },
      -- input window
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode,
          -- add the following keymap to your config
          -- ["<Esc>"] = { "close", mode = { "n", "i" } },
          ['/'] = 'toggle_focus',
          ['<C-l>'] = { 'focus_preview', mode = { 'i', 'n' } },
          ['<C-Down>'] = { 'history_forward', mode = { 'i', 'n' } },
          ['<C-Up>'] = { 'history_back', mode = { 'i', 'n' } },
          ['<C-c>'] = { 'cancel', mode = 'i' },
          ['<C-w>'] = { '<c-s-w>', mode = { 'i' }, expr = true, desc = 'delete word' },
          ['<CR>'] = { 'confirm', mode = { 'n', 'i' } },
          ['<Down>'] = { 'list_down', mode = { 'i', 'n' } },
          ['<Up>'] = { 'list_up', mode = { 'i', 'n' } },
          ['<Esc>'] = 'cancel',
          ['<S-CR>'] = { { 'pick_win', 'jump' }, mode = { 'n', 'i' } },
          ['<S-Tab>'] = { 'select_and_prev', mode = { 'i', 'n' } },
          ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
          ['<a-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
          ['<a-i>'] = { 'toggle_ignored', mode = { 'i', 'n' } },
          ['<a-r>'] = { 'toggle_regex', mode = { 'i', 'n' } },
          ['<a-m>'] = { 'toggle_maximize', mode = { 'i', 'n' } }, -- niiiiiiiiiiiiiiiiiiiice
          ['<a-p>'] = { 'toggle_preview', mode = { 'i', 'n' } },
          ['<a-w>'] = { 'cycle_win', mode = { 'i', 'n' } },
          ['<c-a>'] = { 'select_all', mode = { 'n', 'i' } },
          ['<PageUp>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
          ['<PageDown>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<a-CR>'] = { 'toggle_live', mode = { 'i', 'n' } }, -- niiiiiiiiiiiiiiiiiiiice
          ['<a-d>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
          ['<a-Tab>'] = { 'tab', mode = { 'n', 'i' } },
          ['?'] = 'toggle_help_input',
          ['G'] = 'list_bottom',
          ['gg'] = 'list_top',
          ['j'] = 'list_down',
          ['k'] = 'list_up',
          ['q'] = 'cancel',
          -- ['<a-f>'] = { 'toggle_follow', mode = { 'i', 'n' } },
          -- ['<a-d>'] = { 'inspect', mode = { 'n', 'i' } },
          -- ['<a-s>'] = { 'edit_split', mode = { 'i', 'n' } }, -- niiiiiiiiiiiiiiiiiiiice
          -- ['<c-d>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
          -- ['<c-j>'] = { 'list_down', mode = { 'i', 'n' } },
          -- ['<c-k>'] = { 'list_up', mode = { 'i', 'n' } },
          -- ['<c-n>'] = { 'list_down', mode = { 'i', 'n' } },
          -- ['<c-p>'] = { 'list_up', mode = { 'i', 'n' } },
          -- ['<c-q>'] = { 'qflist', mode = { 'i', 'n' } },
          -- ['<c-u>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
          -- ['<c-r>#'] = { 'insert_alt', mode = 'i' },
          -- ['<c-r>%'] = { 'insert_filename', mode = 'i' },
          -- ['<c-r><c-a>'] = { 'insert_cWORD', mode = 'i' },
          -- ['<c-r><c-f>'] = { 'insert_file', mode = 'i' },
          -- ['<c-r><c-l>'] = { 'insert_line', mode = 'i' },
          -- ['<c-r><c-p>'] = { 'insert_file_full', mode = 'i' },
          -- ['<c-r><c-w>'] = { 'insert_cword', mode = 'i' },
          -- ['<c-h>'] = { 'layout_left', mode = { 'i', 'n' } },
          -- ['<c-j>'] = { 'layout_bottom', mode = { 'i', 'n' } },
          -- ['<c-k>'] = { 'layout_top', mode = { 'i', 'n' } },
          -- ['<c-l>'] = { 'layout_right', mode = { 'i', 'n' } },
        },
        b = {
          minipairs_disable = true,
        },
      },
    },
    layout = {
      layout = {},
    },
    sources = {
      gh_pr = {
        sort = { fields = { 'score:desc', 'idx' } },
      },

      explorer = {
        win = {
          list = {
            keys = {
              ['<C-p>'] = 'focus_preview',
              ['<C-l>'] = '<C-w><C-l>',
            },
          },
        },
      },
    },
  },

  image = {},
  indent = {},
  notifier = {},
  scope = {},
  input = {},
}

-- lazygit
vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>gf', function() Snacks.lazygit.log_file() end, { desc = 'LazyGit File History' })
vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'LazyGit Log' })
vim.keymap.set('n', '<leader>g<leader>', function() Snacks.picker.git_files() end, { desc = 'LazyGit Log' })

-- notifier
vim.keymap.set('n', '<leader>nn', function() Snacks.picker.notifications { confirm = 'focus_preview' } end, { desc = 'Notifications' })
vim.keymap.set('n', '<leader>nd', function() Snacks.notifier.hide() end, { desc = 'Notifications' })

-- pickers
vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.smart() end, { desc = 'Srch Files' })
vim.keymap.set('n', '<leader>.', function() Snacks.picker.recent() end, { desc = 'Buffers (active)' })
vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Srch Grep files' })

-- replace with an autocommand
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'Srch Grep files' })

vim.keymap.set('n', '<leader>si', function() Snacks.picker.icons() end, { desc = 'Search Nerd icons' })
vim.keymap.set('n', '<leader>sC', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = ' Nvim [C]onfiguration files' })
vim.keymap.set('n', '<leader>s:', function() Snacks.picker.command_history() end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = 'Help' })
vim.keymap.set('n', '<leader>sj', function() Snacks.picker.jumps() end, { desc = 'Srch Jumps' })

vim.keymap.set('n', '<leader>uT', function() Snacks.picker.colorschemes() end, { desc = 'Themes' })

-- ui
Snacks.toggle.zoom():map('<leader>wm'):map '<leader>uZ'
Snacks.toggle.zen():map '<leader>uz'
Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
Snacks.toggle.diagnostics():map '<leader>ud'
Snacks.toggle.line_number():map '<leader>ul'
Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
Snacks.toggle.dim():map '<leader>uD'
Snacks.toggle.inlay_hints():map '<leader>uh'
Snacks.toggle.indent():map '<leader>ug'
Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
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

-- buffers
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '\\', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>bo', function() Snacks.bufdelete.other() end, { desc = 'Delete Other Buffers' })
vim.keymap.set('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })

-- Snacks.toggle.treesitter():map '<leader>uT'
-- Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
