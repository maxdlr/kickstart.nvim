local vim = vim
local api = vim.api

function Create_autoCmdGroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup ' .. group_name)
    api.nvim_command 'autocmd!'
    for _, def in ipairs(definition) do
      local command = table.concat(vim.iter({ 'autocmd', def }):flatten():totable(), ' ')
      api.nvim_command(command)
    end
    api.nvim_command 'augroup END'
  end
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
function Gh(repo) return 'https://github.com/' .. repo end

--- Runs `fn` only the first time it is called for a given `key` in a Neovim
--- session. Useful for plugin `setup()` calls that are not idempotent, so that
--- re-sourcing the config (e.g. the "Reload config" command) does not call them
--- again. The flag lives in `vim.g`, which survives a `package.loaded` reset.
---@param key string Unique identifier (used as a `vim.g` flag name).
---@param fn fun() Function to run once.
function Once(key, fn)
  if vim.g[key] then return end
  vim.g[key] = true
  fn()
end

function Snippet_keymap(mode, lhs, snippet, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, function()
    -- If snippet is a function, just call it directly
    if type(snippet) == 'function' then
      snippet()
      return
    end

    local function insert(text) vim.api.nvim_put(vim.split(text, '\n'), 'l', true, true) end
    if opts.from_register then
      local value = vim.fn.getreg(opts.from_register)
      insert((snippet:gsub('%%s', value)))
    elseif opts.prompt then
      vim.ui.input({ prompt = opts.prompt }, function(input)
        if input == nil or input == '' then return end
        insert((snippet:gsub('%%s', input)))
      end)
    else
      insert(snippet)
    end
  end, { desc = opts.desc })
end

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
function Cubic_bezier(x1, y1, x2, y2)
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
function Bezier_timing(x1, y1, x2, y2, total_ms)
  -- Invert the curve: swap (x,y) coords to get progress→time
  local progress_to_time = Cubic_bezier(y1, x1, y2, x2)
  return function(step, total)
    local time_before = progress_to_time((step - 1) / total) * total_ms
    local time_after = progress_to_time(step / total) * total_ms
    return math.max(1, math.floor(time_after - time_before + 0.5))
  end
end
