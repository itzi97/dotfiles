-- vim.cmd [[packadd lsp_extensions.nvim]]
require("lsp_extensions").inlay_hints {
  highlight = "Comment",
  prefix = " » ",
  aligned = true,
  only_current_line = false
}
