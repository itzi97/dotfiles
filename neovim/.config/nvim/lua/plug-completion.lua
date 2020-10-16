-- Add aditional sources
vim.cmd [[packadd completion-nvim]]

local completion = require("completion")
completion.addCompletionSource("vimtex", require("vimtex").complete_item)

vim.cmd [[ augroup lsp_aucmds ]]
vim.cmd [[ au BufEnter * lua require('completion').on_attach() ]]
vim.cmd [[ augroup END ]]

completion.on_attach()
vim.cmd [[ doautoall FileType ]]
