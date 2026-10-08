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
      Snacks.input({ prompt = 'PR Title: ', default = '' }, function(title)
        vim.keymap.set({ 'n', 'i' }, '<Esc>', function() vim.cmd.stopinsert() end, { buffer = 0, desc = 'Stop insert mode' })
        local fillings = ''

        if title == nil then
          vim.notify('PR creation cancelled', vim.log.levels.INFO, { title = 'GH PR Create' })
          return
        end

        if title == '' then
          fillings = '--fill --template "pull_request_template.md"'
        else
          fillings = '--template "pull_request_template.md" --title "' .. title .. '"'
        end

        local output = vim.fn.system('gh pr create --draft --assignee @me ' .. fillings)

        if vim.v.shell_error ~= 0 then
          vim.notify(output, vim.log.levels.ERROR, { title = 'GH PR Create' })
          return
        end

        vim.notify(output, vim.log.levels.INFO, { title = 'GH PR Create' })

        openPrBuffer()
      end)
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
    label = 'View',
    action = openPrBuffer,
    color = '#86B7FF',
  },
  {
    icon = '',
    label = 'Url',
    action = function() vim.fn.setreg('+', vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '')) end,
    color = '#D7FF36',
  },
  {
    icon = '',
    label = 'List',
    action = function() Snacks.picker.gh_pr { state = 'open', drafts = true } end,
    color = '#FFB443',
  },
  {
    icon = '',
    label = 'OpenRepo',
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
