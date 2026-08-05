vim.pack.add { Gh 'beargruug/skipper.nvim' }
require('skipper').setup {
  win_width = 0.3, -- Width (fraction 0-1 for %, or integer for columns)
  win_height = 0.2, -- Height (fraction 0-1 for %, or integer for rows)
  border = 'single', -- Border style ("single", "double", "rounded", "none", or table)
  title = 'Skipper', -- Window title
  filter_favorites = true, -- Hide favorited functions from the main list
  preview = true, -- Show live preview of selected function
  preview_height = 0.2, -- Preview window height
  preview_width = 0.3, -- Preview window width
  preview_position = 'right', -- Preview position ("top", "bottom", "left", "right")
}

vim.keymap.set('n', ']f', '<cmd>ShowFunctionsWindow<CR>', { desc = 'Show functions' })
