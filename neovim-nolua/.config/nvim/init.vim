let g:polyglot_disabled = ['vim', 'tex', 'markdown', 'pandoc']

" Source plugins
source $HOME/.config/nvim/modules/packager.vim

" Source genreal configurations
source $HOME/.config/nvim/modules/settings.vim

" Source interface + color configurations
source $HOME/.config/nvim/modules/colors.vim
source $HOME/.config/nvim/modules/indentLine.vim
source $HOME/.config/nvim/modules/airline.vim
source $HOME/.config/nvim/modules/nerdtree.vim
source $HOME/.config/nvim/modules/startify.vim

" Source language configurations
source $HOME/.config/nvim/modules/pandoc.vim
source $HOME/.config/nvim/modules/vimtex.vim
source $HOME/.config/nvim/modules/vsnip.vim

" LSP, formatting and linting
source $HOME/.config/nvim/modules/neoformat.vim
source $HOME/.config/nvim/modules/lsp.vim
