vim.pack.add { Gh 'lewis6991/gitsigns.nvim' }
local gitsigns = require 'gitsigns'
local picker = require('honcho').honcho_picker

gitsigns.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
  signs_staged = {
    add = { text = '┃' },
    change = { text = '┃' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },
  signs_staged_enable = true,
  on_attach = function(bufnr)
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    -- map('v', '<leader>gs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
    -- map('v', '<leader>gs', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git un[s]tage hunk' })

    -- normal mode
    -- map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    -- map('n', '<leader>gs', gitsigns.reset_hunk, { desc = 'git un[s]tage hunk' })

    -- map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    -- map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })

    -- map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    -- map('n', '<leader>go', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })

    -- map('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
    -- map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    -- map('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
    -- map('n', '<leader>hQ', function() gitsigns.setqflist 'all' end,
    -- { desc = 'git hunk [Q]uickfix list (all files in repo)' })
    -- map('n', '<leader>gq', gitsigns.setqflist, { desc = 'git hunk quickfix list (all changes in this file)' })
    -- Toggles
    -- map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'blame line' })
    -- map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle git intra-line [w]ord diff' })

    -- Text object
    -- map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}

local vCmds = {
  {
    icon = '',
    label = 'Stage Selection',
    action = function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
    color = '#70E354',
  },
  {
    icon = '',
    label = 'Reset Selection',
    action = function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end,
    color = '#E35454',
  },
}

local nCmds = {
  {
    icon = '',
    label = 'Blame',
    action = gitsigns.toggle_current_line_blame,
    color = '#51FFFF',
  },
  {
    icon = '',
    label = 'Preview Hunk',
    action = gitsigns.preview_hunk_inline,
    color = '#51FFFF',
  },
  {
    icon = '',
    label = 'List',
    action = gitsigns.setqflist,
    color = '#51FFFF',
  },
  {
    label = '     ----------------Hunk',
    action = false,
  },
  {
    icon = '',
    label = 'Stage Hunk',
    action = gitsigns.stage_hunk,
    color = '#70E354',
  },
  {
    icon = '',
    label = 'Reset Hunk',
    action = gitsigns.reset_hunk,
    color = '#E35454',
  },
  {
    label = '     ----------------Buffer',
    action = false,
  },
  {
    icon = '',
    label = 'Stage Buffer',
    action = gitsigns.stage_buffer,
    color = '#70E354',
  },
  {
    icon = '',
    label = 'Reset Buffer',
    action = gitsigns.reset_buffer,
    color = '#E35454',
  },
}

vim.keymap.set(
  { 'n' },
  '<leader>gs',
  picker('Git', nCmds, {
    border_color = '#51FFFF',
  }),
  { desc = '󰩤 Git commands' }
)

vim.keymap.set(
  { 'v' },
  '<leader>gs',
  picker('Git', vCmds, {
    border_color = '#51FFFF',
  }),
  { desc = '󰩤 Git commands' }
)
