local picker = require('honcho').honcho_picker

local openPrBuffer = function()
  local prNb = vim.fn.system('gh pr view --json number -q .number'):gsub('%s+$', '')
  local repo = vim.fn.system('gh repo view --json nameWithOwner -q .nameWithOwner'):gsub('%s+$', '')
  vim.cmd.edit(('gh://%s/pr/%s'):format(repo, prNb))
end

local prCmds = {
  {
    icon = '',
    label = 'Create',
    action = function()
      local title = vim.fn.input 'PR Title: '
      -- notify the outputs of the following command
      local output = vim.fn.system('gh pr create --draft --body "" --title "' .. title .. '" --assignee @me')
      if vim.v.shell_error ~= 0 then
        vim.notify(output, vim.log.levels.ERROR, { title = 'GH PR Create' })
        return
      end
      vim.notify(output, vim.log.levels.INFO, { title = 'GH PR Create' })
      openPrBuffer()
    end,
    color = '#7AE35F',
  },
  {
    icon = '',
    label = 'Open',
    action = 'silent !gh pr view --web',
    color = '#6BFFFF',
  },
  {
    icon = '',
    label = 'View/Refresh',
    action = openPrBuffer,
    color = '#86B7FF',
  },
  {
    icon = '',
    label = 'Url - Copy',
    action = function() vim.fn.setreg('+', vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '')) end,
    color = '#D7FF36',
  },
  {
    icon = '',
    label = 'List - All',
    action = function() Snacks.picker.gh_pr() end,
    color = '#FFB443',
  },
  {
    icon = '',
    label = 'List - Branch',
    action = function()
      Snacks.picker.gh_pr {
        branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+$', ''),
      }
    end,
    color = '#FFB443',
  },
  {
    icon = '',
    label = 'Open repo',
    action = 'silent !gh browse',
    color = '#6BFFFF',
  },
}

vim.keymap.set('n', '<leader>gd', function()
  local prNb = vim.fn.system('gh pr view --json number -q .number'):gsub('%s+$', '')
  Snacks.picker.gh_diff { pr = prNb }
end, { desc = 'Diffs' })

vim.keymap.set(
  'n',
  '<leader>gp',
  picker('Pr', prCmds, {
    border_color = '#A1C7FF',
  }),
  { desc = '󰩤 Pr commands' }
)

-- vim.keymap.set(
--   'n',
--   '<leader>gr',
--   picker('Repo', repoCmds, {
--     border_color = '#A1C7FF',
--   }),
--   { desc = '󰩤 Repo commands' }
-- )
