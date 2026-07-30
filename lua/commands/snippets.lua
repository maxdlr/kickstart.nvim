Snippet_keymap('n', '<leader>hf', "const %s = () => {\n  return '%s';\n}\nexport default %s;", {
  prompt = 'Function name: ',
  desc = 'Create exported function',
})

Snippet_keymap('n', '<leader>hc', 'console.log({%s})', {
  from_register = '"',
  desc = 'Log latest yank string',
})

Snippet_keymap('n', '<leader>he', "export { default } from './%s';", {
  prompt = 'default as: ',
  desc = 'Create index default export',
})
