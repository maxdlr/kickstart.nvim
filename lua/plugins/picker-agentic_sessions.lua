-- 5cf3aec2-4b0d-4527-9ec4-e47ba8ee1d71
-- Lists Kiro CLI chat sessions for the current directory in a Snacks picker.
--
-- `agentic.nvim`'s own session picker (<leader>aR, restore_session()) relies on
-- the ACP `session/list` capability, which the Kiro ACP agent does not advertise
-- (it only supports `loadSession`). We bypass that by shelling out to
-- `kiro-cli chat --list-sessions --format json`, which has its own session store
-- independent of ACP, and feeding the session IDs into `restore_session_by_id`,
-- which only needs `loadSession` support.

--- Runs `kiro-cli chat --list-sessions` for the current cwd and parses its JSON output.
--- @return table[]|nil sessions list of { sessionId, title, updatedAt, messageCount, ... }
--- @return string|nil error message, set when the command fails or output can't be parsed
local function get_sessions()
  local output = vim.fn.system { 'kiro-cli', 'chat', '--list-sessions', '--format', 'json' }
  if vim.v.shell_error ~= 0 then return nil, vim.trim(output) end

  local ok, decoded = pcall(vim.json.decode, output)
  if not ok or type(decoded) ~= 'table' then return nil, 'Failed to parse kiro-cli output' end

  -- Output is one entry per cwd; we only ever pass a single cwd, so take the first.
  local entry = decoded[1]
  if not entry or not entry.sessions then return {}, nil end

  return entry.sessions, nil
end

local function format_date(iso)
  if not iso then return 'unknown date' end
  return (iso:sub(1, 16):gsub('T', ' '))
end

local function list_agentic_sessions()
  local sessions, err = get_sessions()
  if err or not sessions then
    vim.notify('Failed to list Kiro sessions: ' .. (err or 'unknown error'), vim.log.levels.ERROR)
    return
  end

  if #sessions == 0 then
    vim.notify('No saved Kiro sessions found for this directory', vim.log.levels.INFO)
    return
  end

  -- Most recently updated first.
  table.sort(sessions, function(a, b) return (a.updatedAt or '') > (b.updatedAt or '') end)

  local items = {}
  for i, session in ipairs(sessions) do
    local title = session.title or '(no title)'
    items[#items + 1] = {
      idx = i,
      score = i,
      text = title,
      session_id = session.sessionId,
      title = title,
      updated_at = session.updatedAt,
      message_count = session.messageCount or 0,
    }
  end

  Snacks.picker {
    title = 'Kiro Sessions',
    items = items,
    format = function(item)
      return {
        { format_date(item.updated_at) .. ' ', 'SnacksPickerComment' },
        { ('%3d msgs '):format(item.message_count), 'SnacksPickerComment' },
        { item.title, 'SnacksPickerLabel' },
      }
    end,
    confirm = function(picker, item)
      picker:close()
      require('agentic').restore_session_by_id(item.session_id)
    end,
  }
end

vim.keymap.set(
  'n',
  '<leader>al', -- ai List sessions
  list_agentic_sessions,
  { desc = 'Agentic: list and restore Kiro sessions' }
)
