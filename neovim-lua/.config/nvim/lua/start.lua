-- Before loading plugins
vim.cmd [[ source $HOME/.config/nvim/modules/prePlugins.vim ]]

-- Load plugins
require("plugins")

vim.cmd [[ let g:deoplete#enable_at_startup = 1 ]]

vim.cmd [[ command! PackerInstall packadd packer.nvim | lua require('plugins').install() ]]
vim.cmd [[ command! PackerUpdate packadd packer.nvim  | lua require('plugins').update()  ]]
vim.cmd [[ command! PackerSync packadd packer.nvim    | lua require('plugins').sync()    ]]
vim.cmd [[ command! PackerClean packadd packer.nvim   | lua require('plugins').clean()   ]]
vim.cmd [[ command! PackerCompile packadd packer.nvim | lua require('plugins').compile() ]]

vim.cmd [[ syntax on ]]
vim.cmd [[ filetype plugin indent on ]]

require("settings").global()

-- Interaces and UI
vim.cmd [[ source $HOME/.config/nvim/modules/indentLine.vim ]]
vim.cmd [[ source $HOME/.config/nvim/modules/colors.vim     ]]
vim.cmd [[ source $HOME/.config/nvim/modules/startify.vim   ]]
vim.cmd [[ source $HOME/.config/nvim/modules/signify.vim    ]]
vim.cmd [[ source $HOME/.config/nvim/modules/statusLine.vim ]]
vim.cmd [[ source $HOME/.config/nvim/modules/luaTree.vim    ]]
vim.cmd [[ source $HOME/.config/nvim/modules/floaterm.vim   ]]
vim.cmd [[ source $HOME/.config/nvim/modules/telescope.vim  ]]

-- Modular configurations
vim.cmd [[ source $HOME/.config/nvim/modules/vimtex.vim   ]]
vim.cmd [[ source $HOME/.config/nvim/modules/vimwiki.vim  ]]
vim.cmd [[ source $HOME/.config/nvim/modules/markdown.vim ]]
vim.cmd [[ source $HOME/.config/nvim/modules/pandoc.vim   ]]
vim.cmd [[ source $HOME/.config/nvim/modules/nvimR.vim    ]]

-- Linting, completion and LSP
vim.cmd [[ source $HOME/.config/nvim/modules/neoformat.vim ]]
vim.cmd [[ source $HOME/.config/nvim/modules/ale.vim       ]]
vim.cmd [[ source $HOME/.config/nvim/modules/lsp.vim       ]]

-- Source pure Lua plugins
require("plug-treesitter")
require("plug-colorizer")
