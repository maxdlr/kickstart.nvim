-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Configured for the JS/TS stack (Node, Express, Next.js server-side,
-- React component code running under Node/Jest). Client-side React/Next
-- code that runs in the browser is debugged via browser devtools, not DAP.

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/mxsdev/nvim-dap-vscode-js',
}

-- nvim-dap-vscode-js spawns the js-debug server as a detached process
-- (dap-vscode-js/utils.lua: uv.spawn { detached = true }). Its cleanup only
-- runs when that process exits on its own; dap.terminate() closes the DAP
-- session but never signals the detached process to stop. This is
-- especially likely to orphan a listener with dev servers that restart
-- themselves (e.g. ts-node-dev --respawn, nodemon), since the debug
-- adapter can lose track of the process across a respawn without dying.
-- Rather than patch the target project, free the port before launching so
-- a leftover listener from a previous session can't block the next one.
local js_debug_port = 8123

local function free_js_debug_port(callback)
  vim.system({ 'lsof', '-ti', ':' .. js_debug_port }, { text = true }, function(result)
    local pid = vim.trim(result.stdout or '')
    if pid == '' then
      vim.schedule(callback)
      return
    end
    vim.system({ 'kill', '-9', pid }, {}, function() vim.schedule(callback) end)
  end)
end

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set(
  'n',
  '<leader>dc',
  function() free_js_debug_port(function() require('dap').continue() end) end,
  { desc = 'Debug: Start/Continue' }
)
vim.keymap.set('n', '<leader>do', function()
  free_js_debug_port(function()
    local dap = require 'dap'
    dap.run(dap.configurations[vim.bo.filetype][1])
  end)
end, { desc = 'Debug: Start session (first config for filetype)' })
vim.keymap.set('n', '<leader>dl', function() require('dap').step_into() end, { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<leader>dj', function() require('dap').step_over() end, { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<leader>dh', function() require('dap').step_out() end, { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>db', function() require('dap').toggle_breakpoint() end, { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' })
vim.keymap.set('n', '<leader>dt', function() require('dap').terminate() end, { desc = 'Debug: Terminate session' })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<leader>ds', function() require('dapui').toggle() end, { desc = 'Debug: See last session result.' })

local dap = require 'dap'
local dapui = require 'dapui'

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- js-debug-adapter (vscode-js-debug) covers Node/TS/JS. It's installed
  -- via mason and wired into nvim-dap-vscode-js below.
  ensure_installed = {
    'js-debug-adapter',
  },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
---@diagnostic disable-next-line: missing-fields
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
  ---@diagnostic disable-next-line: missing-fields
  controls = {
    icons = {
      pause = '⏸',
      play = '▶',
      step_into = '⏎',
      step_over = '⏭',
      step_out = '⏮',
      step_back = 'b',
      run_last = '▶▶',
      terminate = '⏹',
      disconnect = '⏏',
    },
  },
}

-- Change breakpoint icons
-- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
-- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
-- local breakpoint_icons = vim.g.have_nerd_font
--     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
--   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
-- for type, icon in pairs(breakpoint_icons) do
--   local tp = 'Dap' .. type
--   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
--   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
-- end

dap.listeners.after.event_initialized['dapui_config'] = dapui.open
dap.listeners.before.event_terminated['dapui_config'] = dapui.close
dap.listeners.before.event_exited['dapui_config'] = dapui.close

-- Ensures the js-debug adapter process is killed when Neovim exits, so it
-- doesn't linger and hold its control port open for the next session
-- (see: "EADDRINUSE: address already in use ::1:8123").
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    if dap.session() then dap.terminate() end
  end,
})

-- JS/TS debugging via vscode-js-debug (installed as "js-debug-adapter" by mason).
-- Covers Node scripts, Express servers, and Next.js server-side code.
--
-- nvim-dap-vscode-js hardcodes its entrypoint lookup to
-- "<debugger_path>/out/src/vsDebugServer.js", which matches an old
-- vscode-js-debug build layout. Current mason packages ship the prebuilt
-- release at "js-debug/src/dapDebugServer.js" instead (no "out/" dir), so
-- auto-detection fails. Passing debugger_cmd explicitly bypasses that
-- broken path assumption entirely.
local js_debug_path = vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js'

require('dap-vscode-js').setup {
  debugger_cmd = { 'node', js_debug_path },
  adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal' },
}

local js_ts_filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' }

for _, language in ipairs(js_ts_filetypes) do
  dap.configurations[language] = {
    {
      -- Preferred for dev servers that restart themselves on file changes
      -- (ts-node-dev --respawn, nodemon, etc.) — restart = true means the
      -- adapter reconnects automatically after the target process respawns,
      -- rather than needing a fresh debug session each time.
      -- Start the server yourself with the inspector enabled, e.g.:
      --   NODE_OPTIONS=--inspect npm run dev
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to localhost:9229',
      port = 9229,
      address = 'localhost',
      restart = true,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach to process (--inspect)',
      processId = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
      sourceMaps = true,
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
    },
    {
      -- Debug an npm script directly (e.g. "dev", "start") without having
      -- to manually pass --inspect in package.json. Not recommended for
      -- scripts that self-restart (ts-node-dev --respawn, nodemon) — the
      -- debug adapter is spawned detached and can be orphaned across a
      -- respawn. Prefer "Attach to localhost:9229" for those.
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug npm script',
      runtimeExecutable = 'npm',
      runtimeArgs = { 'run-script', 'dev' },
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      sourceMaps = true,
    },
  }
end
