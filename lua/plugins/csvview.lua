vim.pack.add { Gh "hat0uma/csvview.nvim"}
require("csvview").setup {
  ---@module "csvview"
  ---@type CsvView.Options
  opts = {
    parser = { comments = { "#", "//" } },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },
  keys = {
    { "<leader>fuc", "<Cmd>CsvViewToggle delimiter=; display_mode=border header_lnum=1<CR>", desc = "Toggle CSV view" },
  },
  ft = { "csv" },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
}
