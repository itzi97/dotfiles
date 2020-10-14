vim.cmd [[packadd completion-nvim]]
vim.cmd [[packadd vimtex]]

require("completion").addCompletionSource("vimtex", require("vimtex").complete_item)
