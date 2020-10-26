function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " LSP + Deoplete
  call packager#add('prabirshrestha/vim-lsp')
  call packager#add('mattn/vim-lsp-settings')
  call packager#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' })
  call packager#add('lighttiger2505/deoplete-vim-lsp')
  call packager#add('hrsh7th/vim-vsnip')
  call packager#add('hrsh7th/vim-vsnip-integ')

  " Auto formatting (until vim-lsp supports more types)
  call packager#add('sbdchd/neoformat')

  " Language Support
  call packager#add('sheerun/vim-polyglot')

  " Markdown+
  call packager#add('vim-pandoc/vim-pandoc')
  call packager#add('vim-pandoc/vim-pandoc-syntax')
  call packager#add('vim-pandoc/vim-rmarkdown')

  " LaTeX
  call packager#add('lervag/vimtex')

  " R
  call packager#add('jalvesaq/Nvim-R', {'branch': 'master'})

  " Colorscheme + eyecandy
  call packager#add('morhetz/gruvbox')
  call packager#add('kaicataldo/material.vim', { 'branch': 'main' })

  " Eyecandy
  call packager#add('Yggdroot/indentLine')
  call packager#add('rrethy/vim-hexokinase', { 'do': 'make hexokinase' })
  call packager#add('luochen1990/rainbow')

  " Fugitive + Gitgutter
  call packager#add('tpope/vim-fugitive')
  call packager#add('airblade/vim-gitgutter')

  " Startify
  call packager#add('mhinz/vim-startify')

  " Airline
  call packager#add('vim-airline/vim-airline')
  call packager#add('vim-airline/vim-airline-themes')

  " NERDTRee
  call packager#add('preservim/nerdtree')
  call packager#add('Xuyuanp/nerdtree-git-plugin')
  call packager#add('tiagofumo/vim-nerdtree-syntax-highlight')

  " Icons
  call packager#add('ryanoasis/vim-devicons')
endfunction

let g:deoplete#enable_at_startup = 1
let g:rainbow_active = 1
let g:rainbow_conf = {
      \ 'separately': {
      \   'nerdtree': 0,
      \}}

syntax on
filetype plugin indent on

command! PackagerInstall call PackagerInit()      | call packager#install()
command! -bang PackagerUpdate call PackagerInit() |
      \ call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call PackagerInit()        | call packager#clean()
command! PackagerStatus call PackagerInit()       | call packager#status()
