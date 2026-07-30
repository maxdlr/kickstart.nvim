vim.pack.add { Gh 'pwntester/octo.nvim' }
require('octo').setup {
  -- "search" (default) queries GitHub-wide via the search API, which is slow and
  -- returns unrelated accounts. "assignable" scopes reviewer/assignee lookups to
  -- users with access to the current repo (i.e. the org), and is instant.
  users = 'assignable',
}

-- `gh pr create --assignee @me` has no equivalent: `Octo pr create` only accepts
-- an optional `draft` argument and never shells out to `gh pr create`, so any extra
-- arg (like --assignee) is silently ignored. Instead, assign the viewer once the new
-- PR buffer is ready (Octo buffers set filetype "octo" after creation).
local function create_pr_and_assign_me()
  vim.cmd 'Octo pr create'
  local group = vim.api.nvim_create_augroup('OctoAssignMeOnCreate', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'octo',
    once = true,
    callback = function()
      vim.schedule(function() vim.cmd('Octo assignee add ' .. vim.g.octo_viewer) end)
    end,
  })
end

-- The review thread's file path is rendered as virtual text (see octo's
-- write_review_thread_header), so it's never part of the actual buffer text and
-- can't be yanked normally. Pull it from the thread/comment metadata at cursor instead.
local function yank_review_comment_path()
  local octo_utils = require 'octo.utils'
  local buffer = octo_utils.get_current_buffer()
  if not buffer then return end

  local thread = buffer:get_thread_at_cursor()
  local path = thread and thread.path

  if not path then
    local comment = buffer:get_comment_at_cursor()
    path = comment and comment.path
  end

  if not path then
    vim.notify('No review comment file path found at cursor', vim.log.levels.WARN)
    return
  end

  vim.fn.setreg('+', path)
  vim.notify('Copied: ' .. path)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'octo',
  callback = function(args) vim.keymap.set('n', '<leader>gy', yank_review_comment_path, { buffer = args.buf, desc = 'Yank review comment file path' }) end,
})

local function list_prs_from_branch()
  local branch = vim.fn.system('git branch --show-current'):gsub('%s+$', '')
  require('octo.picker').prs { headRefName = branch, states = { 'OPEN', 'CLOSED', 'MERGED' } }
end

local commands = {
  { ' Create', create_pr_and_assign_me, '#7AE35F' },
  { ' Url - Copy', function() vim.fn.setreg('+', vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '')) end, '#D7FF36' },
  { ' View/Refresh', function() vim.cmd('Octo pr edit ' .. vim.fn.system('gh pr view --json number -q .number'):gsub('%s+$', '')) end, '#86B7FF' },
  { ' Open', 'silent !gh pr view --web', '#6BFFFF' },
  { ' List - All', 'Octo pr list', '#FFB443' },
  { ' List - Branch', list_prs_from_branch, '#FFB443' },
}

vim.keymap.set('n', '<leader>gp', Command_picker('Pr', commands, { border_color = '#A1C7FF' }), { desc = 'Pr commands' })
