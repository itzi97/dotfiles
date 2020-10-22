"  ============================================================================
"   __    _   _______   _____  __      __  _______   __    __
"  |  \  | | | ______| /  _  \ \ \    / / |__   __| |  \  /  |
"  |   \ | | | |_____  | | | |  \ \  / /     | |    |   \/   |
"  | |\ \| | | ______| | | | |   \ \/ /      | |    | |\__/| |
"  | | \   | | |_____  | |_| |    \  /     __| |__  | |    | |
"  |_|  \__| |_______| \_____/     \/     |_______| |_|    |_|
"
"  MY NEOVIM CONFIG :)
"
"  Mostly used for:
"  - LaTeX
"  - RMarkdown
"  TODO:
"  - Lsp working with: Vimtex, Texlab.
"  ============================================================================

" Before loading plugins
source $HOME/.config/nvim/modules/prePlugins.vim

" Load plugins
source $HOME/.config/nvim/modules/packer.vim

" After loading plugins
source $HOME/.config/nvim/modules/settings.vim

" Interaces and UI
source $HOME/.config/nvim/modules/indentLine.vim
source $HOME/.config/nvim/modules/colors.vim
source $HOME/.config/nvim/modules/startify.vim
source $HOME/.config/nvim/modules/signify.vim
source $HOME/.config/nvim/modules/statusLine.vim
source $HOME/.config/nvim/modules/luaTree.vim
source $HOME/.config/nvim/modules/floaterm.vim
source $HOME/.config/nvim/modules/telescope.vim

" Modualr configurations
source $HOME/.config/nvim/modules/vimtex.vim
source $HOME/.config/nvim/modules/vimwiki.vim
source $HOME/.config/nvim/modules/markdown.vim
source $HOME/.config/nvim/modules/pandoc.vim
source $HOME/.config/nvim/modules/nvimR.vim

" Linting, completion and LSP
source $HOME/.config/nvim/modules/neoformat.vim
source $HOME/.config/nvim/modules/ale.vim
source $HOME/.config/nvim/modules/lsp.vim

" Source pure Lua plugins
execute 'luafile' . stdpath('config') . '/lua/plug-treesitter.lua'
execute 'luafile' . stdpath('config') . '/lua/plug-colorizer.lua'
