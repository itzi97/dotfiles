-- Add aditional sources
vim.cmd [[packadd completion-nvim]]
require("completion").addCompletionSource("vimtex", require("vimtex").complete_item)
