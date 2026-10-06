-- Lists active toggleterm terminals in a Snacks picker (replaces the previous
-- Telescope-based picker). Terminal lifecycle is still owned by toggleterm.lua.

--- Builds the picker items from the current toggleterm terminals.
---@return table[]
local function get_items()
  local terms = require('toggleterm.terminal').get_all(true)
  local items = {}
  for i, term in ipairs(terms) do
    local name = term.name or ('Terminal #' .. term.id)
    local dir = term.dir or ''
    items[#items + 1] = {
      idx = i,
      score = i,
      text = name .. ' ' .. dir,
      id = term.id,
      name = name,
      dir = dir,
      direction = term.direction,
      term = term,
    }
  end
  return items
end

local function list_terminals()
  local terms = require('toggleterm.terminal').get_all(true)
  if #terms == 0 then
    vim.notify('No toggleterm terminals', vim.log.levels.INFO)
    return
  end

  Snacks.picker {
    title = 'Terminals',
    finder = function() return get_items() end,
    format = function(item)
      return {
        { ('#%d %s '):format(item.id, item.name), 'SnacksPickerLabel' },
        { ('[%s] %s'):format(item.direction, item.dir), 'SnacksPickerComment' },
      }
    end,
    preview = function(ctx)
      ctx.preview:reset()
      local bufnr = ctx.item.term.bufnr
      if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
        ctx.preview:set_lines { 'Terminal is not running.' }
        return
      end
      ctx.preview:set_lines(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
    end,
    confirm = function(picker, item)
      picker:close()
      local term = item.term
      if term:is_open() then
        term:focus()
      else
        term:toggle()
      end
    end,
    actions = {
      kill_terminal = function(picker, item)
        item.term:shutdown()
        picker:find { refresh = true }
      end,
    },
    win = {
      input = {
        keys = {
          ['x'] = { 'kill_terminal', mode = { 'n' } },
        },
      },
    },
  }
end

vim.keymap.set('n', '<leader>tl', list_terminals, { desc = 'List' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'toggleterm',
  callback = function(args) vim.keymap.set('n', '<Tab>', list_terminals, { buffer = args.buf, desc = 'List' }) end,
})
