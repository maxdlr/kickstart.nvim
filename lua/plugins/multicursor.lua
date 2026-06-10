vim.pack.add { { src = Gh 'jake-stewart/multicursor.nvim', branch = '1.0' } }

local mc = require 'multicursor-nvim'

mc.setup {
  -- Whether to disable the plugin when using Neovim in a terminal multiplexer.
  disableInTmux = true,

  -- Whether to disable the plugin in WSL.
  disableInWsl = true,

  -- Whether to show a warning when opening a file with more than `maxFileSize` lines.
  warnFileSize = true,

  -- The maximum file size (in lines) to allow multi-cursor to be enabled for.
  maxFileSize = 10000,
}

local set = vim.keymap.set

local function mc_map(modes, lhs, fn, desc)
  set(modes, lhs, function()
    fn()
    vim.fn['repeat#set'](vim.api.nvim_replace_termcodes(lhs, true, false, true))
  end, { desc = desc })
end

-- Add or skip cursor above/below the main cursor.
-- mc_map({ 'n', 'x' }, '<leader>*<up>', function() mc.lineAddCursor(-1) end, 'Add cursor above')
-- mc_map({ 'n', 'x' }, '<leader>*<down>', function() mc.lineAddCursor(1) end, 'Add cursor below')
-- mc_map({ 'n', 'x' }, '<leader>*s<up>', function() mc.lineSkipCursor(-1) end, 'Skip cursor above')
-- mc_map({ 'n', 'x' }, '<leader>*s<down>', function() mc.lineSkipCursor(1) end, 'Skip cursor below')

-- Add or skip adding a new cursor by matching word/selection
mc_map({ 'n', 'x' }, '<M-down>', function() mc.matchAddCursor(1) end, 'Add cursor to next match')
mc_map({ 'n', 'x' }, '<M-up>', function() mc.matchAddCursor(-1) end, 'Add cursor to previous match')
mc_map({ 'n', 'x' }, '<C-M-down>', function() mc.matchSkipCursor(1) end, 'Skip to next match')
mc_map({ 'n', 'x' }, '<C-M-up>', function() mc.matchSkipCursor(-1) end, 'Skip to previous match')

-- Add and remove cursors with control + left click.
-- set("n", "<c-leftmouse>", mc.handleMouse)
-- set("n", "<c-leftdrag>", mc.handleMouseDrag)
-- set("n", "<c-leftrelease>", mc.handleMouseRelease)

-- Disable and enable cursors.
set({ 'n', 'x' }, '<C-q>', mc.toggleCursor, { desc = 'Toggle multi-cursor' })

-- Mappings defined in a keymap layer only apply when there are
-- multiple cursors. This lets you have overlapping mappings.
mc.addKeymapLayer(function(layerSet)
  -- Select a different cursor as the main one.
  layerSet({ 'n', 'x' }, 'H', mc.prevCursor)
  layerSet({ 'n', 'x' }, 'L', mc.nextCursor)

  -- Delete the main cursor.
  layerSet({ 'n', 'x' }, 'X', mc.deleteCursor)

  -- Enable and clear cursors using escape.
  layerSet('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end)
end)

-- Customize how cursors look.
local hl = vim.api.nvim_set_hl
hl(0, 'MultiCursorCursor', { reverse = true })
hl(0, 'MultiCursorVisual', { link = 'Visual' })
hl(0, 'MultiCursorSign', { link = 'SignColumn' })
hl(0, 'MultiCursorMatchPreview', { link = 'Search' })
hl(0, 'MultiCursorDisabledCursor', { reverse = true })
hl(0, 'MultiCursorDisabledVisual', { link = 'Visual' })
hl(0, 'MultiCursorDisabledSign', { link = 'SignColumn' })
