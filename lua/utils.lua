local vim = vim
local api = vim.api

function Create_autoCmdGroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup ' .. group_name)
    api.nvim_command 'autocmd!'
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten { 'autocmd', def }, ' ')
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

function Snippet_keymap(mode, lhs, snippet, opts)
  opts = opts or {}
  vim.keymap.set(mode, lhs, function()
    -- If snippet is a function, just call it directly
    if type(snippet) == "function" then
      snippet()
      return
    end

    local function insert(text)
      vim.api.nvim_put(vim.split(text, "\n"), "l", true, true)
    end
    if opts.from_register then
      local value = vim.fn.getreg(opts.from_register)
      insert((snippet:gsub("%%s", value)))
    elseif opts.prompt then
      vim.ui.input({ prompt = opts.prompt }, function(input)
        if input == nil or input == "" then return end
        insert((snippet:gsub("%%s", input)))
      end)
    else
      insert(snippet)
    end
  end, { desc = opts.desc })
end
