-- Hide yanks matching any of these from the picker (Lua patterns, anchored full-match).
-- e.g. add '%s+' to drop all whitespace-only yanks.
local yank_history_excludes = { ' ', '\n' }

vim.keymap.set('n', '<leader>p', function()
  local yh = require 'yanky.telescope.yank_history'
  require('yanky.telescope.mapping').state.is_visual = false

  local all = require('yanky.history').all()
  local results = {}
  for index, entry in ipairs(all) do
    local excluded = false
    for _, pat in ipairs(yank_history_excludes) do
      if entry.regcontents and entry.regcontents:match('^' .. pat .. '$') then
        excluded = true
        break
      end
    end
    if not excluded then
      entry.history_index = index -- keep real index so delete (d/<c-x>) targets the right entry
      results[#results + 1] = entry
    end
  end

  local opts = require('telescope.themes').get_cursor {
    winblend = 5,
    previewer = true,
    layout_config = { width = 0.5, height = 0.3, preview_width = 0.4, preview_cutoff = 1 },
  }
  opts.history_length = #all
  require('telescope.pickers')
    .new(opts, {
      prompt_title = 'Yank history',
      finder = require('telescope.finders').new_table { results = results, entry_maker = yh.gen_from_history(opts) },
      attach_mappings = yh.attach_mappings,
      previewer = yh.previewer(),
      sorter = require('telescope.config').values.generic_sorter(opts),
    })
    :find()
end, { desc = 'Yank history' })
