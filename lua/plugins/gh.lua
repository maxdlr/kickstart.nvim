local picker = require('honcho').honcho_picker

local function ghPrUrl() return vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '') end
local function ghPrNumber() return vim.fn.system('gh pr view --json number -q .number'):gsub('%s+$', '') end
local function ghRepoName() return vim.fn.system('gh repo view --json nameWithOwner -q .nameWithOwner'):gsub('%s+$', '') end
local function ghCurrentBranchName() return vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+$', '') end

local openPrBuffer = function()
  local repo = ghRepoName()
  local prNb = ghPrNumber()

  if (ghCurrentBranchName() == 'main' or ghCurrentBranchName() == 'master' or ghCurrentBranchName() == 'gedeon-v2') and prNb == '' then
    vim.notify("You're on " .. ghCurrentBranchName(), vim.log.levels.INFO, { title = 'GH PR View' })
    return
  end

  local file = ('gh://%s/pr/%s'):format(repo, prNb)

  vim.cmd.edit(file)
  -- if file ~= vim.api.nvim_buf_get_name(0) then
  --   Snacks.win {
  --     file = file,
  --     position = 'float',
  --     backdrop = 60,
  --     height = 0.9,
  --     width = 0.9,
  --     zindex = 50,
  --     wo = {
  --       spell = false,
  --       wrap = true,
  --       -- signcolumn = 'yes',
  --       -- statuscolumn = ' ',
  --       -- conceallevel = 3,
  --       number = true,
  --       relativenumber = true,
  --     },
  --     bo = {
  --       bufhidden = 'hide',
  --     },
  --   }
  -- end
end

local function ghLastCommitSubject() return vim.fn.system('git log -1 --pretty=%s'):gsub('%s+$', '') end

local createAutoPr = function()
  local templatePath = './.github/pull_request_template.md'
  local title = ghLastCommitSubject()
  local cmd

  if vim.fn.filereadable(templatePath) == 1 then
    cmd = 'gh pr create --draft --assignee @me --title ' .. vim.fn.shellescape(title) .. ' --body-file ' .. vim.fn.shellescape(templatePath)
  else
    cmd = 'gh pr create --draft --assignee @me --title ' .. vim.fn.shellescape(title) .. ' --fill'
  end

  local output = vim.fn.system(cmd)

  if vim.v.shell_error ~= 0 then
    -- a pull request for branch "test-pr" into branch "master" already exists:
    if output:match 'already exists:' then
      vim.notify('PR already exists: ' .. ghPrNumber(), vim.log.levels.INFO, { title = 'GH PR Create' })
      openPrBuffer()
      return
    end

    vim.notify(output, vim.log.levels.ERROR, { title = 'GH PR Create' })
    return
  end

  vim.notify(output, vim.log.levels.INFO, { title = 'GH PR Create' })

  openPrBuffer()
end

local prCmds = {
  {
    icon = '',
    label = 'Create',
    action = createAutoPr,
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
    action = function() vim.fn.setreg('+', ghPrUrl()) end,
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

vim.keymap.set('n', '<leader>gd', function() Snacks.picker.gh_diff { pr = ghPrNumber() } end, { desc = 'Diffs' })

vim.keymap.set(
  'n',
  '<leader>gp',
  picker('Pr', prCmds, {
    border_color = '#A1C7FF',
  }),
  { desc = '󰩤 Pr commands' }
)
