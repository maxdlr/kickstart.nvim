local noicePlugins = {
  Gh 'MunifTanjim/nui.nvim',
  Gh 'rcarriga/nvim-notify',
}
vim.pack.add(noicePlugins)
vim.pack.add { Gh 'folke/noice.nvim' }

require('notify').setup {
  -- How long notifications stay visible (ms)
  timeout = 3000,

  -- Animation style: 'fade_in_slide_out' | 'fade' | 'slide' | 'static'
  -- stages = Bezier_timing(0.25, 1.0, 0.5, 1.0, 50),
  stages = 'slide',

  -- Max width of the notification window (fraction of editor width or absolute columns)
  -- max_width = 50,

  -- Minimum width
  -- min_width = 20,

  -- Frames per second for animations (higher = smoother but more redraws)
  -- fps = 30,

  -- Time for the notification to fade in (ms) — only for fade-based stages
  -- You can also define fully custom stages, see below
}

require('noice').setup {
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
  },
  routes = {
    {
      filter = {
        event = 'msg_show',
        any = {
          { find = '%d+L, %d+B' },
          { find = '; after #%d+' },
          { find = '; before #%d+' },
        },
      },
      view = 'mini',
    },
  },
  presets = {
    inc_rename = true,
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
}

local map = vim.keymap.set

map('c', '<S-Enter>', function() require('noice').redirect(vim.fn.getcmdline()) end, { desc = 'Redirect Cmdline' })
map('n', '<leader>nn', function() require('noice').cmd 'last' end, { desc = 'Noice Last Message' })
map('n', '<leader>nh', function() require('noice').cmd 'history' end, { desc = 'Noice History' })
-- map('n', '<leader>na', function() require('noice').cmd 'all' end, { desc = 'Noice All' })
map('n', '<leader>nd', function() require('noice').cmd 'dismiss' end, { desc = 'Dismiss All' })
map('n', '<leader>nl', function() require('noice').cmd 'pick' end, { desc = 'Noice Picker (Telescope/FzfLua)' })

map({ 'i', 'n', 's' }, '<c-f>', function()
  if not require('noice.lsp').scroll(4) then return '<c-f>' end
end, { silent = true, expr = true, desc = 'Scroll Forward' })
map({ 'i', 'n', 's' }, '<c-b>', function()
  if not require('noice.lsp').scroll(-4) then return '<c-b>' end
end, { silent = true, expr = true, desc = 'Scroll Backward' })
