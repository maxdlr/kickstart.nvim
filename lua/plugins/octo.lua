vim.pack.add { Gh 'pwntester/octo.nvim' }
require('octo').setup()

local commands = {
  { 'Create', 'Octo pr create --assignee @me' },
  { 'Commits', 'Octo pr commits' },
  { 'Url (copy)', function() vim.fn.setreg('+', vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '')) end },
  { 'Open', 'silent !gh pr view --web' },
  { 'View', function() vim.cmd('Octo pr edit ' .. vim.fn.system('gh pr view --json number -q .number'):gsub('%s+$', '')) end },
  { 'List', 'Octo pr list' },
}

vim.keymap.set('n', '<leader>gp', Command_picker('Pr', commands), { desc = 'Pr commands' })
