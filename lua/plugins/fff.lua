vim.pack.add({ Gh 'dmtrKovalenko/fff.nvim' })

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = false, show_scores = true },
  prompt_vim_mode = true,
  keymaps = {
    close = '<Esc>',
    select = '<CR>',
    select_split = '<C-s>',
    select_vsplit = '<C-v>',
    select_tab = '<C-t>',
    move_up = { '<Up>', '<C-p>' },
    move_down = { '<Down>', '<C-n>' },
    preview_scroll_up = '<C-u>',
    preview_scroll_down = '<C-d>',
    toggle_debug = '<F2>',
    cycle_grep_modes = '<S-Tab>',
    cycle_previous_query = '<C-Up>',
    toggle_select = '<Tab>',
    send_to_quickfix = '<C-q>',
    focus_list = '<C-h>',
    focus_preview = '<C-l>',
  },
  preview = {
    enabled = true,
    max_size = 10 * 1024 * 1024,
    chunk_size = 8192,
    binary_file_threshold = 1024,
    imagemagick_info_format_str = '%m: %wx%h, %[colorspace], %q-bit',
    line_numbers = true,
    cursorlineopt = 'both',
    wrap_lines = false,
    filetypes = {
      svg = { wrap_lines = true },
      markdown = { wrap_lines = true },
      text = { wrap_lines = true },
    },
  },
  layout = {
    height = 0.9,
    width = 0.8,
    prompt_position = 'top',    -- or 'top'
    preview_position = 'right', -- 'left' | 'right' | 'top' | 'bottom'
    preview_size = 0.6,
    flex = { size = 130, wrap = 'top' },
    show_scrollbar = true,
    path_shorten_strategy = 'middle_number', -- 'middle_number' | 'middle' | 'end'
    anchor = 'center',
  },
  grep = {
    max_file_size = 10 * 1024 * 1024,
    max_matches_per_file = 100,
    smart_case = true,
    time_budget_ms = 150,
    modes = { 'regex', 'fuzzy' },
    trim_whitespace = true,
  },
}

vim.keymap.set('n', '<leader><leader>', function() require('fff').find_files() end, { desc = 'FFFind files' })

vim.keymap.set('n', '<leader>/', function() require('fff').live_grep() end, { desc = 'FFFind files' })

vim.keymap.set({ 'n', 'v' }, '<leader>sw', function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
  { desc = '[S]earch current [W]ord' })
