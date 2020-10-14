vim.cmd [[packadd completion-nvim]]

require("completion").addCompletionSource("vimtex", require("vimtex").complete_item)
require("completion").addCompletionSource("pandoc", require("pandoc").complete_item)
