-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { Gh 'nvim-mini/mini.nvim' }

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
local ai = require 'mini.ai'
ai.setup {
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter { -- code block
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    },
    f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' }, -- function
    c = ai.gen_spec.treesitter { a = '@class.outer', i = '@class.inner' }, -- class
    t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
    d = { '%f[%d]%d+' }, -- digits
    e = { -- Word with case
      { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
      '^().*()$',
    },
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call { name_pattern = '[%w_]' }, -- without dot in function name
  },
  -- mappings = {
  --   around_next = 'aa',
  --   inside_next = 'ii',
  -- },
}

-- Indent scope motions: ]i / [i to jump to start/end of scope
require('mini.indentscope').setup {
  symbol = '│',
  options = { try_as_border = true },
  mappings = {
    goto_top = '[i',
    goto_bottom = ']i',
  },
}

--- Cubic-bezier easing — works exactly like CSS `cubic-bezier(x1, y1, x2, y2)`.
---
--- The curve is defined by two control points P1=(x1,y1) and P2=(x2,y2).
--- P0=(0,0) and P3=(1,1) are implicit (animation goes from 0% to 100%).
---
--- x-axis = time progress (0→1), y-axis = animation progress (0→1).
---   - x1, y1: first control point  — influences the START of the curve
---   - x2, y2: second control point — influences the END of the curve
---
--- Common presets to try:
---   ease:        (0.25, 0.1,  0.25, 1.0)  — slight slow start, gentle deceleration
---   ease-in:     (0.42, 0,    1.0,  1.0)  — slow start, accelerates to the end
---   ease-out:    (0,    0,    0.58, 1.0)  — fast start, gradually decelerates
---   ease-in-out: (0.42, 0,    0.58, 1.0)  — slow start and slow end, fast middle
---   smooth:      (0.25, 1.0,  0.5,  1.0)  — quick start, long smooth deceleration
---   overshoot:   (0.2,  1.5,  0.3,  1.0)  — bursts past target, settles back (y1 > 1)
---
--- Play with values at https://cubic-bezier.com/
local function cubic_bezier(x1, y1, x2, y2)
  -- A bezier curve is parametric: both x and y are functions of t ∈ [0,1].
  -- Given an x (time progress), we need to find the corresponding t,
  -- then compute y (animation progress) at that t.
  -- We solve for t numerically using Newton-Raphson (8 iterations is plenty).
  local function solve_t(x)
    local t = x -- initial guess: t ≈ x (works well for most curves)
    for _ = 1, 8 do
      -- Bezier x(t) - target x (we want this to be 0)
      local cx = 3 * x1 * t * (1 - t) ^ 2 + 3 * x2 * (1 - t) * t ^ 2 + t ^ 3 - x
      -- Derivative dx/dt (slope of x with respect to t)
      local dx = 3 * x1 * (1 - t) ^ 2 - 6 * x1 * t * (1 - t) + 6 * x2 * t * (1 - t) - 3 * x2 * t ^ 2 + 3 * t ^ 2
      if math.abs(dx) < 1e-6 then break end
      t = t - cx / dx -- Newton step
    end
    return t
  end

  -- Returns y (animation progress) for a given x (time progress)
  return function(x)
    local t = solve_t(x)
    return 3 * y1 * t * (1 - t) ^ 2 + 3 * y2 * (1 - t) * t ^ 2 + t ^ 3
  end
end

--- Creates a mini.animate timing function that distributes `total_ms` across
--- all animation steps using the given cubic-bezier easing.
---
--- Control points use CSS cubic-bezier semantics (x = time, y = progress):
--- @param x1 number First control point X (0–1). Higher = delayed start.
--- @param y1 number First control point Y. >1 overshoots, 0 = flat start.
--- @param x2 number Second control point X (0–1). Lower = earlier deceleration.
--- @param y2 number Second control point Y. Usually 1 for smooth landing.
--- @param total_ms number Total animation duration in milliseconds.
---
--- How it works: mini.animate steps are equal-distance scroll increments.
--- The timing function returns how many ms to wait before the next step.
--- CSS bezier maps time→progress, but we need progress→time (the inverse),
--- so we swap x↔y in the control points internally.
--- Short delays = fast movement, long delays = slow movement.
local function bezier_timing(x1, y1, x2, y2, total_ms)
  -- Invert the curve: swap (x,y) coords to get progress→time
  local progress_to_time = cubic_bezier(y1, x1, y2, x2)
  return function(step, total)
    local time_before = progress_to_time((step - 1) / total) * total_ms
    local time_after = progress_to_time(step / total) * total_ms
    return math.max(1, math.floor(time_after - time_before + 0.5))
  end
end

require('mini.animate').setup {
  cursor = { enable = false },
  scroll = {
    enable = true,
    -- cubic-bezier(0.25, 1.0, 0.5, 1.0) over 250ms — quick start, long smooth deceleration
    timing = bezier_timing(0.25, 1.0, 0.5, 1.0, 50),
    subscroll = require('mini.animate').gen_subscroll.equal { max_output_steps = 40 },
  },
  open = { enable = false },
  close = { enable = false },
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

-- Simple and easy statusline.
--  You could remove this setup call if you don't like it,
--  and try some other statusline plugin
-- local statusline = require 'mini.statusline'
-- Set `use_icons` to true if you have a Nerd Font
-- statusline.setup { use_icons = vim.g.have_nerd_font }

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
-- statusline.section_location = function() return '%2l:%-2v' end

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim
