vim.pack.add { Gh 'carlos-algms/agentic.nvim' }

local picker = require('honcho').honcho_picker
local agentic = require 'agentic'

-- - @type agentic.PartialUserConfig
agentic.setup {
  -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
  provider = 'kiro-acp', -- setting the name here is all you need to get started

  diff_preview = {
    enabled = true,
    layout = 'inline', -- "split" or "inline"
    center_on_navigate_hunks = true,
  },

  windows = {
    position = 'right', -- "right", "left", or "bottom"
    width = '40%', -- Sidebar width (position = "right" or "left")
    height = '30%', -- Panel height (position = "bottom")

    chat = { buffer_name = function(parts) return 'AI: ' .. parts.title end },
    input = { buffer_name = 'Prompt' },
    code = { buffer_name = 'Code Snippets' },
    files = { buffer_name = 'Files' },
    diagnostics = { buffer_name = 'Diagnostics' },
    todos = { buffer_name = 'Tasks' },
  },

  folding = {
    tool_calls = {
      enabled = true,
      threshold = 30,
      fold_on_error = false,
    },
  },

  widget = {
    close = 'q', -- String for a single keybinding
    change_mode = {
      {
        '<S-Tab>',
        mode = { 'i', 'n', 'v' }, -- Specify modes for this keybinding
      },
    },

    -- switch_provider = '<localLeader>s', -- Switch ACP provider
    -- switch_model = '<localLeader>M', -- Switch model
    -- change_thought_level = '<localLeader>t', -- Select thought effort level
    open_options = '', -- Open options modal
    -- select_session = '<localLeader>l', -- List and open a session
    next_session = '<localLeader>]', -- Open the next session
    prev_session = '<localLeader>[', -- Open the previous session
    -- destroy_session = '<localLeader>D', -- Destroy the current session
    -- stop_generation = '<localLeader>x', -- Stop current generation or tool execution
  },

  prompt = {
    submit = {
      '<CR>', -- Normal mode, just Enter
      {
        '<C-s>',
        mode = { 'n', 'v' },
      },
    },

    paste_image = {
      {
        '<localLeader>p',
        mode = { 'n' },
      },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>aa', function() agentic.toggle() end, { desc = 'Toggle Agentic Chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>af', function() agentic.add_selection_or_file_to_context() end, { desc = 'Add file or selection to Agentic to Context' })
vim.keymap.set({ 'n', 'v' }, '<leader>an', function() agentic.new_session() end, { desc = 'New Agentic Session' })
vim.keymap.set({ 'n', 'v' }, '<leader>aR', function() agentic.restore_session() end, { desc = 'Agentic Restore session', silent = true })
vim.keymap.set('n', '<leader>ad', function() agentic.add_current_line_diagnostics() end, { desc = 'Add current line diagnostic to Agentic' })
vim.keymap.set('n', '<leader>aD', function() agentic.add_buffer_diagnostics() end, { desc = 'Add all buffer diagnostics to Agentic' })
vim.keymap.set('n', '<leader>ar', function()
  vim.ui.input({ prompt = 'Session ID: ' }, function(session_id)
    if session_id and session_id ~= '' then agentic.restore_session_by_id(session_id) end
  end)
end, { desc = 'Agentic restore session by id' })

local agentic_nav_augroup = vim.api.nvim_create_augroup('agentic-insert-nav', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = agentic_nav_augroup,
  pattern = 'AgenticInput',
  callback = function(event)
    local directions = {
      ['<C-h>'] = 'move_cursor_left',
      ['<C-j>'] = 'move_cursor_down',
      ['<C-k>'] = 'move_cursor_up',
      ['<C-l>'] = 'move_cursor_right',
    }
    for lhs, fn_name in pairs(directions) do
      vim.keymap.set('i', lhs, function()
        vim.cmd 'stopinsert'
        require('smart-splits')[fn_name]()
      end, { buffer = event.buf, desc = 'Move focus out of Agentic prompt' })
    end
  end,
})

vim.api.nvim_create_autocmd('WinEnter', {
  group = agentic_nav_augroup,
  callback = function()
    if vim.bo.filetype == 'AgenticInput' then vim.schedule(function() vim.cmd 'startinsert' end) end
  end,
})

local cmds = {
  { label = '------ Chat ------', action = false },
  {
    icon = '',
    label = 'Stop generation',
    action = function() agentic.stop_generation() end,
    color = '#FFA41B',
  },
  {
    icon = '',
    label = 'Switch model',
    action = function() agentic.switch_model() end,
    color = '#438EFF',
  },
  { label = '------ Sessions ------', action = false },
  {
    icon = '',
    label = 'Close session',
    action = function() agentic.destroy_session() end,
    color = '#FF0000',
  },
  {
    icon = '',
    label = 'Select session',
    action = function() agentic.select_session() end,
    color = '#438EFF',
  },
}

-- create a keymap but only if in one of the Agentic buffers.
vim.api.nvim_create_autocmd('FileType', {
  group = agentic_nav_augroup,
  pattern = 'Agentic*',
  callback = function(event)
    vim.keymap.set('n', '<leader>ao', picker('Agentic', cmds, { border_color = '#FFFFFF' }), {
      desc = 'Agentic options',
    })
  end,
})

-- :lua require("agentic").toggle()	Toggle chat sidebar
-- :lua require("agentic").open(opts)	Open chat sidebar (keep open if already visible)
-- :lua require("agentic").close()	Hide chat sidebar (session keeps running; nothing is destroyed)
-- :lua require("agentic").add_selection()	Add visual selection to context
-- :lua require("agentic").add_file()	Add current file to context
-- :lua require("agentic").add_selection_or_file_to_context()	Add selection (if any) or file to the context
-- :lua require("agentic").add_files_to_context(opts)	Add a list of file paths or buffer numbers to context
-- :lua require("agentic").add_current_line_diagnostics()	Add diagnostics at cursor line to context
-- :lua require("agentic").add_buffer_diagnostics()	Add all diagnostics from current buffer to context
-- :lua require("agentic").new_session()	Start a new session; choose what happens to the current one
-- :lua require("agentic").destroy_session(opts)	Destroy a session and its widget
-- :lua require("agentic").select_session()	Pick any live session from a list and open it here
-- :lua require("agentic").next_session()	Open the next session, wrapping at the end
-- :lua require("agentic").prev_session()	Open the previous session, wrapping at the start
-- :lua require("agentic").new_session_with_provider()	Pick a provider, then start a new session with it
-- :lua require("agentic").stop_generation()	Stop current generation or tool execution (session stays active)
-- :lua require("agentic").restore_session()	Show provider's session picker to restore a previous session
-- :lua require("agentic").restore_session_by_id(session_id)	Restore a session by its ID
-- :lua require("agentic").switch_provider()	Switch ACP provider mid-session (shows picker, preserves history)
-- :lua require("agentic").rotate_layout()	Rotate window position through layouts (right → bottom → left)
