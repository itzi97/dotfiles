" Neovim configuration without lua

" Before sourcing plugins
let g:ale_completion_enabled = 0
let g:polyglot_disabled = [
  \ 'autoindent',
  \ 'vim',
  \ 'tex',
  \ 'markdown',
  \ 'pandoc'
  \]

" Source plugins
source $HOME/.config/nvim/modules/packager.vim

" Source genreal configurations
source $HOME/.config/nvim/modules/settings.vim

" Color + Eyecandy
source $HOME/.config/nvim/modules/colors.vim
source $HOME/.config/nvim/modules/indentLine.vim

" Interfaces & Navigation
source $HOME/.config/nvim/modules/sneak.vim
source $HOME/.config/nvim/modules/airline.vim
source $HOME/.config/nvim/modules/nerdtree.vim
source $HOME/.config/nvim/modules/startify.vim
source $HOME/.config/nvim/modules/floaterm.vim
source $HOME/.config/nvim/modules/fzf.vim

" Source language configurations
source $HOME/.config/nvim/modules/pandoc.vim
source $HOME/.config/nvim/modules/vimtex.vim

" LSP, formatting and linting
source $HOME/.config/nvim/modules/ale.vim
source $HOME/.config/nvim/modules/neoformat.vim
source $HOME/.config/nvim/modules/lsp.vim
source $HOME/.config/nvim/modules/ultisnips.vim

" Source lua configs
execute 'luafile' . stdpath('config') . '/lua/plug-colorizer.lua'
