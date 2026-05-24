vim.pack.add { Gh 'nvim-zh/colorful-winsep.nvim' }
require('colorful-winsep').setup {
  event = { "WinLeave" },
  animate = {
    ---@type "shift"|"progressive"|false
    enabled = 'progressive', -- false to disable or choose a option below (e.g. "shift") and set option for it if needed
    -- shift = {
    --   delay = 16,        -- about 60fps
    --   frames = 15,       -- how many frames are required to complete the animation
    -- },
    progressive = {
      delay = 16,
      vertical_lerp_factor = 0.15, -- between 0 and 1
      horizontal_lerp_factor = 0.15, -- between 0 and 1
    },
  },
}
