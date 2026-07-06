vim.pack.add { Gh 'chrisgrieser/nvim-early-retirement' }
require('early-retirement').setup {
  retirementAgeMins = 5,
  minimumBufferNum = 5,
  ignoreFilenamePattern = '.env',
}
