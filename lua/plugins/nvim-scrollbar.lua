local colors = require 'neon.colors'

vim.pack.add { Gh 'petertriho/nvim-scrollbar' }

require('scrollbar').setup {
  handle = {
    color = colors.bg_highlight,
  },
  marks = {
    Search = { color = colors.orange },
    Error = { color = colors.error },
    Warn = { color = colors.warning },
    Info = { color = colors.warning },
    Hint = { color = colors.hint },
    Misc = { color = colors.purple },
  },
}
