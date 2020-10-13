vim.cmd [[ packadd nvim-treesitter ]]

require("nvim-treesitter")
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  -- highlight = {enable = true}, -- TODO: Make work
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  }
}
