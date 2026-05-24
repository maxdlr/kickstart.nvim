vim.pack.add {
  Gh 'okuuva/auto-save.nvim',
}

require('auto-save').setup {
  -- keys = {
  --   { "<leader>uv", "<cmd>ASToggle<CR>", desc = "Toggle auto-save" },
  -- },
  version = '*', -- see https://devhints.io/semver, alternatively use '*' to use the latest tagged release
  -- event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
  opts = {
    -- This section controls the messages shown in the command line
    -- execution_message = {
    --   message = function()
    --     return "Auto-save on" -- Alternatively, keep it enabled but return an empty string
    --   end,
    --   -- dim = 0.18,               -- (Optional) dims the color of the message
    --   -- cleaning_interval = 1250, -- (Optional) how long the message stays visible
    -- },
    -- If you also want to disable the notification in the status line/floating win
    trigger_events = {                                                       -- See :h events
      immediate_save = { 'BufLeave', 'FocusLost', 'QuitPre', 'VimSuspend' }, -- vim events that trigger an immediate save
      defer_save = { 'InsertLeave', 'TextChanged' },                         -- vim events that trigger a deferred save (saves after `debounce_delay`)
      cancel_deferred_save = { 'InsertEnter' },                              -- vim events that cancel a pending deferred save
    },
    debounce_delay = 1000,

    -- condition = nil,                                                         -- write a function to determine which files to save
    -- write_all_buffers = false,
    -- noautocmd = false,
    -- lockmarks = false,
  },
}
