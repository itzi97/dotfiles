if &compatible
  set nocompatible
endif

let g:polyglot_disabled = ['vim', 'tex', 'markdown', 'pandoc']

" Source plugins
source $HOME/.vim/modules/packager.vim

" Source genreal configurations
source $HOME/.vim/modules/settings.vim

" Source interface + color configurations
source $HOME/.vim/modules/colors.vim
source $HOME/.vim/modules/indentLine.vim
source $HOME/.vim/modules/airline.vim
source $HOME/.vim/modules/nerdtree.vim
source $HOME/.vim/modules/startify.vim

" Source language configurations
source $HOME/.vim/modules/pandoc.vim
source $HOME/.vim/modules/vimtex.vim

" LSP, formatting and linting
source $HOME/.vim/modules/neoformat.vim
source $HOME/.vim/modules/lsp.vim
source $HOME/.vim/modules/ultisnips.vim
