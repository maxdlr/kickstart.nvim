-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local plugins = {
  { src = Gh 'nvim-neo-tree/neo-tree.nvim', version = vim.version.range '*' },
  Gh 'nvim-lua/plenary.nvim',
  Gh 'MunifTanjim/nui.nvim',
}

if vim.g.have_nerd_font then
  table.insert(plugins, Gh 'nvim-tree/nvim-web-devicons') -- not strictly required, but recommended
end

vim.pack.add(plugins)

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree reveal<CR>', { desc = 'Explorer', silent = true })

require('neo-tree').setup {
  filesystem = {
    default_component_configs = {
      container = {
        enable_character_fade = true,
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '󰜌',
        provider = function(icon, node, state) -- default icon provider utilizes nvim-web-devicons if available
          if node.type == 'file' or node.type == 'terminal' then
            local success, web_devicons = pcall(require, 'nvim-web-devicons')
            local name = node.type == 'terminal' and 'terminal' or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
        use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
      },
      modified = {
        symbol = '[+]',
        highlight = 'NeoTreeModified',
      },
      name = {
        trailing_slash = false,
        use_filtered_colors = true, -- Whether to use a different highlight when the file is filtered (hidden, dotfile, etc.).
        use_git_status_colors = true,
        highlight = 'NeoTreeFileName',
      },
      git_status = {
        symbols = {
          -- Change type
          added = '', -- or "✚"
          modified = '', -- or ""
          deleted = '✖', -- this can only be used in the git_status source
          renamed = '󰁕', -- this can only be used in the git_status source
          -- Status type
          untracked = '',
          ignored = '',
          unstaged = '󰄱',
          staged = '',
          conflict = '',
        },
      },
      last_modified = {
        enabled = true,
        width = 20, -- width of the column
        required_width = 88, -- min width of window required to show this column
      },
    },
    filtered_items = {
      never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
        '.DS_Store',
        --"thumbs.db"
      },
      always_show = { -- remains visible even if other settings would normally hide it
        '.gitignore',
      },
      hide_by_name = {
        'node_modules',
      },
      always_show_by_pattern = { -- uses glob style patterns
        '.env*',
      },
      hide_hidden = true,
    },
    window = {
      position = 'left',
      mappings = {
        ['<leader>e'] = 'close_window',
      },
    },
  },
}
