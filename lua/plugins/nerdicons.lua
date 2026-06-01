vim.pack.add { Gh 'glepnir/nerdicons.nvim' }
require('nerdicons').setup {
  border = 'single', -- Border
  prompt = '󰨭 ', -- Prompt Icon
  preview_prompt = ' ', -- Preview Prompt Icon
  width = 0.5, -- float window width
  down = '<down>', -- Move down in preview
  up = '<up>', -- Move up in preview
  copy = '<Tab>', -- Copy to the clipboard
  register = '*', -- Register to copy to
}

vim.keymap.set('n', '<leader>$i', '<Cmd>NerdIcons<CR>', { desc = 'Search Nerd icons' })
