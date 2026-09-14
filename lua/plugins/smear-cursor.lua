vim.pack.add { Gh 'sphamba/smear-cursor.nvim' }

require('smear_cursor').setup {
  stiffness = 0.8, -- Higher value = faster dash to the target
  trailing_stiffness = 0.4, -- Trail follows closely behind
  anticipation = 0.2, -- Adds a slight "wind-up" before the dash
  damping = 0.8, -- Less "floaty," more precise stops

  max_length = 15, -- Shorter trail for a sharper look
  -- gamma = 1.8, -- Slightly darker color blending

  time_interval = 15, -- Slightly faster refresh for 60fps+ feel

  -- same color as current colorschime cursor color
  cursor_color = '#1DFFCC',
}
