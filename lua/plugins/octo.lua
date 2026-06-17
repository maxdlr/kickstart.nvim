vim.pack.add { Gh 'pwntester/octo.nvim' }
require('octo').setup()

local commands = {
  { 'Create', 'Octo pr create --assignee @me' },
  { 'Open', 'silent !gh pr view --web' },
  { 'Copy url', function() vim.fn.setreg('+', vim.fn.system('gh pr view --json url -q .url'):gsub('%s+$', '')) end },
  { 'List', function() Snacks.picker.gh_pr() end },
}

vim.keymap.set('n', '<leader>gp', Command_picker('Pr', commands), { desc = 'Pr commands' })
