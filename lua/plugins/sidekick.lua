vim.pack.add { Gh 'folke/sidekick.nvim' }
require('sidekick').setup {
  cli = {
    win = {
      layout = 'right',
      float = { width = 0.9, height = 0.9 },
      split = { width = 80, height = 20 },
    },
    tools = {
      kiro = {
        cmd = { 'kiro-cli' },
        is_proc = '\\<kiro\\>',
        url = 'https://kiro.dev',
      },
    },
    mux = {
      backend = 'tmux',
      enabled = true,
    },
  },
}

-- Kill (not just detach) a sidekick CLI session, including sessions that are
-- detached from the current window or running externally in tmux/zellij.
-- `cli.close()` only detaches; the underlying mux session keeps running.
local function kill_session(state)
  if not state or not state.session then return end
  local Session = require 'sidekick.cli.session'
  local session = state.session

  -- Detach sidekick first so its internal state stays consistent, and close
  -- the embedded terminal (which also stops its job) if one is attached.
  pcall(Session.detach, session)
  if state.terminal then pcall(function() state.terminal:close() end) end

  local backend = session.mux_backend or session.backend
  if backend == 'tmux' then
    if session.tmux_pane_id then
      vim.system { 'tmux', 'kill-pane', '-t', session.tmux_pane_id }
    elseif session.mux_session then
      vim.system { 'tmux', 'kill-session', '-t', session.mux_session }
    end
  elseif backend == 'zellij' then
    if session.mux_session then vim.system { 'zellij', 'delete-session', '--force', session.mux_session } end
  else
    -- plain terminal backend: terminate the tool processes directly
    for _, pid in ipairs(session.pids or {}) do
      pcall(vim.uv.kill, pid, 'sigterm')
    end
  end

  vim.notify(('Killed sidekick session `%s`'):format(state.tool.name), vim.log.levels.INFO)
end

-- Pick any running session (attached, detached, or external) and kill it.
local function kill_pick()
  require('sidekick.cli.ui.select').select {
    filter = { started = true },
    cb = function(state)
      if state then kill_session(state) end
    end,
  }
end

-- Kill every running session without prompting.
local function kill_all()
  local states = require('sidekick.cli.state').get { started = true }
  if vim.tbl_isempty(states) then
    vim.notify('No sidekick sessions to kill', vim.log.levels.INFO)
    return
  end
  for _, state in ipairs(states) do
    kill_session(state)
  end
end

local map = vim.keymap.set

map('n', 'Ì', function() require('sidekick').nes_jump_or_apply() end, { expr = true, desc = 'Goto/Apply Next Edit Suggestion' })
map('n', '<leader>ae', function() require('sidekick.nes').toggle() end, { desc = 'Toggle Next Edit Suggestions' })
map('n', '<leader>au', function() require('sidekick').update() end, { expr = true, desc = 'Update Next Edit Suggestion' })
map('n', '<leader>aa', function() require('sidekick.cli').toggle() end, { desc = 'Sidekick Toggle CLI' })
map('n', '<leader>as', function() require('sidekick.cli').select() end, { desc = 'Select CLI' })
map('n', '<leader>ad', function() require('sidekick.cli').close() end, { desc = 'Detach a CLI Session' })
map({ 'x', 'n' }, '<leader>at', function() require('sidekick.cli').send { msg = '{this}' } end, { desc = 'Send This' })
map('n', '<leader>af', function() require('sidekick.cli').send { msg = '{file}' } end, { desc = 'Send File' })
map('x', '<leader>av', function() require('sidekick.cli').send { msg = '{selection}' } end, { desc = 'Send Visual Selection' })
map({ 'n', 'x' }, '<leader>ap', function() require('sidekick.cli').prompt() end, { desc = 'Sidekick Select Prompt' })
map('n', '<leader>ac', function() require('sidekick.cli').toggle { name = 'copilot', focus = true } end, { desc = 'Sidekick Toggle Copilot' })
map('n', '<leader>ak', function() require('sidekick.cli').toggle { name = 'kiro', focus = true } end, { desc = 'Sidekick Toggle Kiro' })

map('n', '<leader>ax', kill_pick, { desc = 'Kill a CLI Session (incl. detached)' })
map('n', '<leader>aX', kill_all, { desc = 'Kill all CLI Sessions' })
