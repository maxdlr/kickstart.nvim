vim.pack.add { Gh 'akinsho/toggleterm.nvim' }
require('toggleterm').setup {
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  hide_numbers = false,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_caret = true,
  persist_mode = true,
  close_on_exit = true,
  shell = vim.o.shell,
  auto_scroll = true,
  float_opts = {
    border = 'curved',
    winblend = 10,
    width = function() return math.floor(vim.o.columns * 0.85) end,
    height = function() return math.floor(vim.o.lines * 0.85) end,
    title_pos = 'center',
  },
  on_open = function(term)
    vim.wo.number = true
    vim.wo.relativenumber = true
    local opts = { buffer = term.bufnr }
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    -- vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    -- vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    -- vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
  end,
}

local Terminal = require('toggleterm.terminal').Terminal
local term_count = 10

local float_term = Terminal:new { direction = 'float', count = 1 }

-- local vert_term = Terminal:new { direction = 'vertical', count = 2 }
-- local horiz_term = Terminal:new { direction = 'horizontal', count = 3 }

local function new_term()
  term_count = term_count + 1
  Terminal:new({ direction = 'float', count = term_count }):open()
end

-- local start_dev_term = Terminal:new { cmd = 'make dev', direction = 'float', count = 4 }
-- print(vim.inspect(start_dev_term))

vim.keymap.set('n', '<leader>tt', function() float_term:toggle() end, { desc = 'Terminal' })
vim.keymap.set('n', '<leader>tn', new_term, { desc = 'New' })
-- vim.keymap.set('n', '<leader>Tt', function() float_term:toggle() end, { desc = 'Terminal (float)' })
-- vim.keymap.set('n', '<leader>Tl', function() vert_term:toggle() end, { desc = 'Terminal (right)' })
-- vim.keymap.set('n', '<leader>Tj', function() horiz_term:toggle() end, { desc = 'Terminal (bottom)' })
-- vim.keymap.set('n', '<leader>ts', function() start_dev_term:toggle() end, { desc = 'Terminal (lazygit)' })

-- vim.keymap.set('n', '<leader>tx', function()
--   local terms = require('toggleterm.terminal').get_all(true)
--   for _, term in ipairs(terms) do
--     if term:is_open() then
--       term:shutdown()
--       return
--     end
--   end
-- end, { desc = 'Terminal (kill active)' })
