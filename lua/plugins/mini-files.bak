vim.pack.add { Gh 'nvim-mini/mini.nvim' }

require('mini.files').setup {
  mappings = {
    close = '<Esc>',
    -- go_in = 'l',
    -- go_in_plus = 'L',
    -- go_out = 'h',
    -- go_out_plus = 'H',
    -- mark_goto = "'",
    -- mark_set = 'm',
    -- reset = '<BS>',
    -- reveal_cwd = '@',
    -- show_help = 'g?',
    -- synchronize = '=',
    -- trim_left = '<',
    -- trim_right = '>',
  },
  windows = {
    -- Maximum number of windows to show side by side
    max_number = 3,
    -- Whether to show preview of file/directory under cursor
    preview = false,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 50,
  },
}

vim.keymap.set('n', '<leader>e', function() require('mini.files').open(vim.api.nvim_buf_get_name(0)) end, { desc = 'Files Open' })

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesWindowOpen',
  callback = function(args)
    vim.wo[args.data.win_id].number = true
    vim.wo[args.data.win_id].relativenumber = true
  end,
})

vim.api.nvim_set_hl(0, 'MiniFilesGitAdd', { default = true, link = 'MiniDiffSignAdd', fg = '' })
vim.api.nvim_set_hl(0, 'MiniFilesGitChange', {
  -- default = true,
  -- link = 'MiniDiffSignChange',
  fg = '#FF9E0D',
})
vim.api.nvim_set_hl(0, 'MiniFilesGitDelete', {
  -- default = true,
  -- link = 'MiniDiffSignDelete',
  fg = '#FF2828',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferUpdate',
  callback = function(args)
    local buf_id = args.data.buf_id
    local cwd = vim.fn.getcwd()
    local output = vim.fn.systemlist('git -C ' .. vim.fn.shellescape(cwd) .. ' status --porcelain .')
    if vim.v.shell_error ~= 0 then return end

    local status = {}
    for _, line in ipairs(output) do
      local s, file = line:match '^(..)%s+(.+)$'
      if s and file then
        local full = vim.fn.fnamemodify(cwd .. '/' .. file, ':p')
        status[full] = vim.trim(s)
      end
    end

    local ns = vim.api.nvim_create_namespace 'mini_files_git'
    vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)
    local n_lines = vim.api.nvim_buf_line_count(buf_id)
    for i = 1, n_lines do
      local entry = MiniFiles.get_fs_entry(buf_id, i)
      if entry then
        local path = vim.fn.fnamemodify(entry.path, ':p')
        local s = status[path]
        if s then
          local hl = s:match '[?]' and 'MiniFilesGitAdd' or s:match 'M' and 'MiniFilesGitChange' or s:match 'D' and 'MiniFilesGitDelete' or nil
          if hl then vim.api.nvim_buf_set_extmark(buf_id, ns, i - 1, 0, { line_hl_group = hl }) end
        end
      end
    end
  end,
})
