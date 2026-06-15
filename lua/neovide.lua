vim.o.guifont = 'FiraCode Nerd Font:h14'

if vim.g.neovide then
  vim.opt.linespace = 4 -- Put anything you want to happen only in Neovide here

  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_window_blurred = true
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5

  vim.g.neovide_floating_corner_radius = 10.0

  vim.g.neovide_show_border = false

  vim.g.neovide_position_animation_length = 0.5
  vim.g.neovide_scroll_animation_length = 0.2

  vim.g.neovide_padding_top = 20
  vim.g.neovide_padding_bottom = 0
  vim.g.neovide_padding_right = 5
  vim.g.neovide_padding_left = 5

  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2

  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.experimental_layer_grouping = false
end
