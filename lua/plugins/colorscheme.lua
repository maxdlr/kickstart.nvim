---@diagnostic disable: inject-field, undefined-doc-name
-- [[ Colorscheme ]]
-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command under that to load whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
-- vim.pack.add { gh 'folke/tokyonight.nvim' }
-- ---@diagnostic disable-next-line: missing-fields
-- require('tokyonight').setup {
--   styles = {
--     comments = { italic = false }, -- Disable italics in comments
--   },
-- }

vim.pack.add { Gh 'Zeioth/neon.nvim' }
---@diagnostic disable-next-line: missing-fields
require('neon').setup {
  dim_inactive = false,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
  },

  ---@param highlights neon.Highlights -- table<string, vim.api.keyset.highlight>
  ---@param colors ColorScheme -- palette colors (bg, fg, blue, red, green, yellow, etc.)
  on_highlights = function(highlights, colors)
    highlights.LineNrAbove = { fg = '#FF4081', bold = false }
    highlights.LineNrBelow = { fg = '#F4EF00', bold = false }
    highlights.CursorLineNr = { fg = '#FFFFFF', bold = true }
    highlights.CursorLine = { bg = '#403345', bold = true }
    highlights.CursorColumn = { bg = '#403345', bold = true }
    highlights.WinSeparator = { fg = '#FF4081', bg = '#000000' }

    -- highlights.LspReferenceText = { underline = false, bg = '#403345' }
    -- highlights.LspReferenceRead = { underline = false, bg = '#403345' }
    -- highlights.LspReferenceWrite = { underline = false, bg = '#403345' }

    -- -- Telescope: differentiate file paths from match content
    -- highlights.TelescopeResultsIdentifier = { fg = '#7aa2f7' }
    -- highlights.TelescopeResultsLineNr = { fg = '#565f89' }
    -- highlights.TelescopeMatching = { fg = '#ff9e64', bold = true }
  end,
}

-- Load the colorscheme here.
-- Like many other themes, this one has different styles, and you could load
-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
vim.cmd.colorscheme 'neon-cherrykiss-storm'
