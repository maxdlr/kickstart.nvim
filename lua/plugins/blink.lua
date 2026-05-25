local blink_deps = {
  Gh 'xzbdmw/colorful-menu.nvim',
  Gh 'nvim-tree/nvim-web-devicons',
  Gh 'bydlw98/blink-cmp-env',
  Gh 'moyiz/blink-emoji.nvim',
  Gh 'marcoSven/blink-cmp-yanky',
  Gh 'mikavilpas/blink-ripgrep.nvim',
}

vim.pack.add(blink_deps)
vim.pack.add { { src = Gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }

require('blink.cmp').setup {
  keymap = {

    -- 'default' (recommended) for mappings similar to built-in completions
    --   <c-y> to accept ([y]es) the completion.
    --    This will auto-import if your LSP supports it.
    --    This will expand snippets if the LSP sent a snippet.
    -- 'super-tab' for tab to accept
    -- 'enter' for enter to accept
    -- 'none' for no mappings
    --
    -- For an understanding of why the 'default' preset is recommended,
    -- you will need to read `:help ins-completion`
    --
    -- No, but seriously. Please read `:help ins-completion`, it is really good!
    --
    -- All presets have the following mappings:
    -- <tab>/<s-tab>: move to right/left of your snippet expansion
    -- <c-space>: Open menu or open docs if already open
    -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
    -- <c-e>: Hide menu
    -- <c-k>: Toggle signature help
    --
    -- See `:help blink-cmp-config-keymap` for defining your own keymap
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },

    -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
    --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  },

  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },

  completion = {
    -- NEW: This replaces keyword_strategy
    trigger = {
      -- When true, it will show the completion menu as you type
      show_on_keyword = true,
      -- When true, it will show the completion menu after a trigger character (like . or :)
      show_on_trigger_character = true,
      -- (Default: 'prefix') 'prefix' = matches the start of the word, 'any' = matches anywhere
      -- keyword_range = "any",
    },

    -- Ghost text (the gray text after your cursor)
    ghost_text = {
      enabled = false, -- Set to false to prevent clashing with Copilot
    },

    -- The list of items in the menu
    list = {
      selection = {
        preselect = true, -- Automatically highlight the first item
        auto_insert = true, -- Insert the text as you cycle (like VS Code)
      },
    },

    -- The appearance of the popup menu (the PUM)
    --
    menu = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      direction_priority = function() ---@return ("n"|"s")[]
        local ctx = require('blink.cmp').get_context()
        local item = require('blink.cmp').get_selected_item()
        if ctx == nil or item == nil then return { 's', 'n' } end

        local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
        local is_multi_line = item_text:find '\n' ~= nil

        -- after showing the menu upwards, we want to maintain that direction
        -- until we re-open the menu, so store the context id in a global variable
        if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
          vim.g.blink_cmp_upwards_ctx_id = ctx.id
          return { 'n', 's' }
        end
        return { 's', 'n' }
      end,
      enabled = true,
      min_width = 15,
      max_height = 10,
      border = 'rounded', -- Options: "none", "single", "double", "rounded", "solid", "shadow"
      winblend = 0, -- Transparency (0-100)

      -- Color highlighting
      winhighlight = 'Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None',

      draw = {
        gap = 1,
        padding = 1,
        columns = {
          { 'kind_icon' },
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },

        components = {
          kind_icon = {
            ellipsis = false,
            text = function(ctx)
              -- local lspkind = require("lspkind")
              local icon = ctx.kind_icon
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then icon = dev_icon end
                local ok, lspkind = pcall(require, 'lspkind')
                if ok then icon = lspkind.symbolic(ctx.kind, { mode = 'symbol' }) end
              else
              end

              return icon .. ctx.icon_gap
            end,
            highlight = function(ctx)
              local hl = 'BlinkCmpKind' .. ctx.kind or require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx)
              if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                if dev_icon then hl = dev_hl end
              end
              return hl
            end,
          },
          -- kind_icon = {
          --   ellipsis = false,
          --   text = function(ctx) return ctx.kind_icon .. ctx.icon_gap end,
          --   highlight = function(ctx) return "BlinkCmpKind" .. ctx.kind end,
          -- },
          label = {
            width = { fill = true, max = 60 },
            text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
            highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
          },
          kind = {
            text = function(ctx) return '(' .. ' ' .. ctx.kind .. ' ' .. ')' end,
            highlight = 'BlinkCmpKind',
          },
        },
      },
    },

    -- The "Documentation" window (Extra info on the side)
    documentation = {
      auto_show = true, -- Set to false if you only want it when you ask for it
      auto_show_delay_ms = 500,
      window = {
        border = 'rounded',
        winhighlight = 'Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None',
      },
    },
  },

  sources = {
    providers = {
      buffer = {
        opts = {
          get_bufnrs = function()
            return vim.iter(vim.api.nvim_list_wins())
              :map(vim.api.nvim_win_get_buf)
              :filter(function(buf) return vim.bo[buf].buftype == '' end)
              :totable()
          end,
        },
      },

      emoji = {
        module = 'blink-emoji',
        name = 'Emoji',
        score_offset = -10, -- Tune by preference
        opts = {
          insert = true, -- Insert emoji (default) or complete its name
          ---@type string|table|fun():table
          trigger = ':',
          kind_icon = '󰅍',
        },
      },

      yank = {
        name = 'yank',
        module = 'blink-yanky',
        score_offset = -10, -- Tune by preference
        opts = {
          minLength = 10,
          onlyCurrentFiletype = true,
          trigger_characters = { '.' },
          kind_icon = '󰅍',
        },
      },

      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        score_offset = -15, -- Tune by preference
        -- see the full configuration below for all available options
        ---@module "blink-ripgrep"
        ---@type blink-ripgrep.Options
        opts = { prefix_min_len = 4 },
        transform_items = function(_, items)
          for _, item in ipairs(items) do
            -- example: append a description to easily distinguish rg results
            item.labelDetails = {
              description = '(rg)',
            }
          end
          return items
        end,
      },
    },
    
    default = {
      'lsp',
      'path',
      'snippets',
      'buffer',
      'emoji',
      -- 'yank',
      "ripgrep"
    },
  },

  snippets = { preset = 'luasnip' },

  -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
  -- which automatically downloads a prebuilt binary when enabled.
  --
  -- By default, we use the Lua implementation instead, but you may enable
  -- the rust implementation via `'prefer_rust_with_warning'`
  --
  -- See `:help blink-cmp-config-fuzzy` for more information
  fuzzy = { implementation = 'prefer_rust_with_warning' },

  -- Shows a signature help window while you type arguments for a function
  signature = { enabled = true },
}
