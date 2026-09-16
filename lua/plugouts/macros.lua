---@param snippet string|function
---@param opts {prompt: string, from_register: string?}
---@return nil
local function snippet_maker(snippet, opts)
  opts = opts or {}
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
end

local cmds = {
  {
    'const fn = () => {}; export;',
    function()
      snippet_maker("const %s = () => {\n  return '%s';\n}\nexport default %s;", {
        prompt = 'Function name: ',
      })
    end,
  },
  {
    '󱞩 console.log({ <  > });',
    function()
      snippet_maker('console.log({%s})', {
        from_register = '"',
      })
    end,
  },
  {
    'export { default } from "./";',
    function()
      snippet_maker("export { default } from './%s';", {
        prompt = 'default as: ',
      })
    end,
  },
}

vim.keymap.set(
  'n',
  '<leader>h',
  Command_picker('Macros', cmds, {
    border_color = '#ff9e64',
  }),
  { desc = 'Macros' }
)
