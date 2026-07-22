vim.pack.add { Gh 'folke/flash.nvim' }

require('flash').setup {
  -- labels = 'asdfghjklqwertyuiopzxcvbnm',
  labels = '123456789',
  search = {
    multi_window = false,
    mode = 'fuzzy',
  },
  modes = {
    search = {
      enabled = true,
      highlight = { backdrop = false },
      mode = 'fuzzy',
    },
    char = {
      enabled = false,
    },
    treesitter = {
      enabled = false,
    },
  },
  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = 'FlashMatch',
      current = 'FlashCurrent',
      backdrop = 'FlashBackdrop',
      label = 'FlashLabel',
    },
  },
  label = {
    -- show label after the match
    after = true,
    -- show label before the match
    before = false,
    -- label position style
    -- "overlay": label overlays the match
    -- "eol": label at end of line
    -- "right_align": label right-aligned
    -- "inline": label inline with text
    style = 'overlay',
    -- allow uppercase labels
    uppercase = true,
    -- for custom label format with padding/styling
    format = function(opts) return { { ' ' .. opts.match.label .. ' ', opts.hl_group } } end,
    rainbow = { enabled = false },
  },
}

-- Define custom highlight groups with your colors
-- Uncomment and modify these to customize label appearance:
vim.api.nvim_set_hl(0, 'FlashLabel', { fg = '#ff007c', bg = '#000000', bold = true })
-- vim.api.nvim_set_hl(0, 'FlashMatch', { fg = '#ffffff', bg = '#3e4452' })
-- vim.api.nvim_set_hl(0, 'FlashCurrent', { fg = '#000000', bg = '#ff007c' })
-- vim.api.nvim_set_hl(0, 'FlashBackdrop', { fg = '#545862' })

vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
