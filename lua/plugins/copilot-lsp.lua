vim.pack.add { Gh 'copilotlsp-nvim/copilot-lsp' }

-- 9061a85e-2f5f-4ab3-9596-d430a577d98c
-- ac881e01-41ba-4c7e-815f-94958f4202ca
--
--

vim.g.copilot_nes_debounce = 500

-- Reuse copilot.lua's authenticated binary instead of the Mason-installed copy. Each
-- copilot-language-server binary/path keeps its own GitHub auth token, so running two
-- separate binaries (one per plugin) requires signing in twice. This keeps a single
-- authenticated session shared between copilot.lua and copilot-lsp.
vim.lsp.config('copilot_ls', {
  cmd = function(dispatchers)
    local ok, binary = pcall(require, 'copilot.lsp.binary')
    local path = ok and (binary.server_path or binary.get_server_path()) or nil
    if not path or vim.fn.executable(path) == 0 then
      -- Fallback: copilot.lua hasn't resolved/installed its binary yet, use the
      -- Mason-installed binary on PATH instead.
      path = 'copilot-language-server'
    end
    return vim.lsp.rpc.start({ path, '--stdio' }, dispatchers)
  end,
})

vim.lsp.enable 'copilot_ls'
vim.keymap.set('n', '<M-h>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  local state = vim.b[bufnr].nes_state
  if state then
    -- Try to jump to the start of the suggestion edit.
    -- If already at the start, then apply the pending suggestion and jump to the end of the edit.
    local _ = require('copilot-lsp.nes').walk_cursor_start_edit()
      or (require('copilot-lsp.nes').apply_pending_nes() and require('copilot-lsp.nes').walk_cursor_end_edit())
    return nil
  else
    -- Resolving the terminal's inability to distinguish between `TAB` and `<C-i>` in normal mode
    return '<C-i>'
  end
end, { desc = 'Accept Copilot NES suggestion', expr = true })

vim.keymap.set('i', '<M-h>', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.b[bufnr].nes_state then
    local _ = require('copilot-lsp.nes').walk_cursor_start_edit()
      or (require('copilot-lsp.nes').apply_pending_nes() and require('copilot-lsp.nes').walk_cursor_end_edit())
  end
end, { desc = 'Accept Copilot NES suggestion' })

vim.keymap.set('n', '<esc>', function()
  if not require('copilot-lsp.nes').clear() then
    -- No pending NES suggestion to clear, fall back to the default <Esc> behavior
    vim.cmd 'nohlsearch'
  end
end, { desc = 'Clear Copilot suggestion or fallback' })
