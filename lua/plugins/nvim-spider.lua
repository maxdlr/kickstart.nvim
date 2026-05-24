vim.pack.add { Gh 'chrisgrieser/nvim-spider' }
require('spider').setup {
  skipInsignificantPunctuation = true,
  subwordMovement = true,
  consistentOperatorPending = false, -- see the README for details
  customPatterns = {}, -- see the README for details
}
