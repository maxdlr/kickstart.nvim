vim.pack.add { Gh 'folke/snacks.nvim' }
require('snacks').setup {
  dashboard = {
    preset = {
      header = [[
     ___          ___          __
    /  /\        /  /\        |  |\
   /  /::|      /  /::\       |  |:|
  /  /:|:|     /  /:/\:\      |  |:|
 /  /:/|:|__  /  /::\ \:\     |__|:|__
/__/:/_|::::\/__/:/\:\_\:\____/__/::::\
\__\/  /~~/:/\__\/  \:\/:/\__\::::/~~~~
      /  /:/      \__\::/    |~~|:|
     /  /:/       /  /:/     |  |:|
    /__/:/       /__/:/      |__|:|
    \__\/        \__\/        \__\|
]],
      keys = {
        -- { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
        -- { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
        -- { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
        -- { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
        -- { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
        { icon = '🫢', key = 's', desc = 'Restore Session', action = function() require('persistence').load() end },
        { icon = '🖕', key = 'q', desc = 'Quit', action = ':qa' },
      },
    },
    sections = {
      { section = 'header' },
      { section = 'keys', gap = 1, padding = 1 },
      { section = 'recent_files', padding = 1 },
    },
  },

  explorer = {
    win = { list = { wo = { number = true } } },
  },

  zen = {
    toggles = {
      dim = false,
      git_signs = true,
      mini_diff_signs = true,
      width = '',
    },
    win = {
      width = 160,
    },
  },
}
