vim.pack.add {
  Gh 'okuuva/auto-save.nvim',
}

require('auto-save').setup {
  trigger_events = { -- See :h events
    immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' }, -- vim events that trigger an immediate save
    defer_save = { 'InsertLeave', 'TextChanged' }, -- vim events that trigger a deferred save (saves after `debounce_delay`)
    cancel_deferred_save = { 'InsertEnter' }, -- vim events that cancel a pending deferred save
  },
  debounce_delay = 1000,
}
