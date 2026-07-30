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

---@param repo string
---@return string
function Gh(repo) return 'https://github.com/' .. repo end

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

local DEFAULT_COMMAND_COLOR = '#FFFFFF'

--- Cache of "prefix:hex" -> highlight group name, so repeated colors (or repeated
--- picker invocations) don't keep redefining the same highlight group.
local color_hl_cache = {}

--- Gets (or lazily creates) a highlight group named `prefix<HEX>` that sets `hl_field` to `hex`.
--- @param prefix string Highlight group name prefix, e.g. "CommandPickerColor"
--- @param hex string Hex color, e.g. "#FF8800"
--- @param hl_field? string Highlight field to set, "fg" (default) or "bg"
--- @return string Highlight group name
local function get_color_hl(prefix, hex, hl_field)
  hl_field = hl_field or 'fg'
  local cache_key = prefix .. ':' .. hex .. ':' .. hl_field
  local cached = color_hl_cache[cache_key]
  if cached then return cached end

  local hl_name = prefix .. hex:gsub('^#', '')
  vim.api.nvim_set_hl(0, hl_name, { [hl_field] = hex })
  color_hl_cache[cache_key] = hl_name
  return hl_name
end

--- Telescope border highlight groups controlled per-picker-instance by temporarily
--- overriding them, then restoring on close (Telescope hardcodes these group names
--- in its layout code, so there's no per-instance config option to hook into).
local BORDER_HL_GROUPS = { 'TelescopePromptBorder', 'TelescopeResultsBorder', 'TelescopePreviewBorder', 'TelescopePromptTitle' }

--- Sentinel action value marking a command entry as a non-selectable separator.
--- Use it as the `action` field, e.g. `{ '───────────', Command_picker_separator }`.
Command_picker_separator = false

--- Creates a Telescope dropdown picker from a list of commands.
--- @param title string Picker prompt title
--- @param commands {[1]: string, [2]: string|function|false, [3]: string?}[] List of {label, action, color} pairs.
---   action: a Lua function, a string Ex command (without <Cmd>/<CR> wrapping), or
---   `Command_picker_separator` (false) to render the entry as a non-selectable divider.
---   color: optional hex color (e.g. "#FF8800") for the label text. Defaults to white.
--- @param opts? {border_color?: string} border_color: optional hex color (e.g. "#7aa2f7") for the
---   picker's border. Defaults to the global TelescopeBorder highlight.
function Command_picker(title, commands, opts)
  opts = opts or {}
  return function()
    local pickers = require 'telescope.pickers'
    local finders = require 'telescope.finders'
    local actions = require 'telescope.actions'
    local action_state = require 'telescope.actions.state'
    local themes = require 'telescope.themes'
    local config = require 'telescope.config'

    local restore_border_hl
    if opts.border_color then
      -- Save current border highlight definitions, override them for this picker,
      -- and queue a restore for when the picker closes.
      local previous = {}
      for _, group in ipairs(BORDER_HL_GROUPS) do
        previous[group] = vim.api.nvim_get_hl(0, { name = group, link = false })
        vim.api.nvim_set_hl(0, group, { fg = opts.border_color })
      end
      restore_border_hl = function()
        for group, hl in pairs(previous) do
          vim.api.nvim_set_hl(0, group, hl)
        end
      end
    end

    pickers
      .new(
        themes.get_dropdown {
          winblend = 5,
          layout_config = { prompt_position = 'top', width = 0.13, height = #commands + 4 },
        },
        {
          prompt_title = title,
          finder = finders.new_table {
            results = commands,
            entry_maker = function(e)
              local is_separator = e[2] == Command_picker_separator
              local hl_group = get_color_hl('CommandPickerColor', e[3] or (is_separator and '#555555' or DEFAULT_COMMAND_COLOR))
              return {
                value = e,
                -- Empty ordinal keeps separators from matching search input, so
                -- typing never accidentally "selects" a divider via fuzzy match.
                ordinal = is_separator and '' or e[1],
                display = function(entry) return entry.value[1], { { { 0, #entry.value[1] }, hl_group } } end,
              }
            end,
          },
          sorter = config.values.generic_sorter {},
          attach_mappings = function(bufnr, map)
            if restore_border_hl then
              -- Scoped to this picker's prompt buffer only, so it doesn't leak
              -- into other Telescope pickers the way overriding the shared
              -- actions.close post-hook would.
              vim.api.nvim_create_autocmd('BufWinLeave', {
                buffer = bufnr,
                once = true,
                callback = restore_border_hl,
              })
            end

            -- Skip over separator rows when moving the selection, so they can
            -- never be landed on (and therefore never look "selectable").
            local function skip_separators(move)
              return function()
                move(bufnr)
                local guard = 0
                while action_state.get_selected_entry().value[2] == Command_picker_separator and guard < #commands do
                  move(bufnr)
                  guard = guard + 1
                end
              end
            end
            local move_next = skip_separators(actions.move_selection_next)
            local move_prev = skip_separators(actions.move_selection_previous)
            map({ 'i', 'n' }, '<Down>', move_next)
            map({ 'i', 'n' }, '<C-n>', move_next)
            map({ 'i', 'n' }, '<Up>', move_prev)
            map({ 'i', 'n' }, '<C-p>', move_prev)

            actions.select_default:replace(function()
              local action = action_state.get_selected_entry().value[2]
              -- Separators are inert: ignore the selection and keep the picker open.
              if action == Command_picker_separator then return end
              actions.close(bufnr)
              if type(action) == 'function' then
                action()
              else
                vim.cmd(action)
              end
            end)
            return true
          end,
        }
      )
      :find()
  end
end
