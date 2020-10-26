function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " {{{ Linting, completion, formatting

  " LSP + Deoplete
  call packager#add('prabirshrestha/vim-lsp')
  call packager#add('mattn/vim-lsp-settings')
  call packager#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' })
  call packager#add('lighttiger2505/deoplete-vim-lsp')
  call packager#add('sirver/UltiSnips')
  call packager#add('honza/vim-snippets')
  call packager#add('thomasfaingnaert/vim-lsp-snippets')
  call packager#add('thomasfaingnaert/vim-lsp-ultisnips')

  " Linting when LSP not available
  call packager#add('dense-analysis/ale')

  " Auto formatting (until vim-lsp supports more types)
  call packager#add('sbdchd/neoformat')

  " }}}

  " {{{ Languages

  " Language Support
  call packager#add('sheerun/vim-polyglot')

  " Go
  call packager#add('fatih/vim-go', { 'do': ':GoInstallBinaries', 'type': 'opt' })

  " Markdown+
  call packager#add('vim-pandoc/vim-pandoc')
  call packager#add('vim-pandoc/vim-pandoc-syntax')
  call packager#add('vim-pandoc/vim-rmarkdown')

  " LaTeX
  call packager#add('lervag/vimtex')

  " R
  call packager#add('jalvesaq/Nvim-R', {'branch': 'master'})

  " }}}

  " {{{ Color & Eyecandy

  " Color
  call packager#add('morhetz/gruvbox')
  call packager#add('kaicataldo/material.vim', { 'branch': 'main' })

  " Eyecandy
  call packager#add('Yggdroot/indentLine')
  call packager#add('luochen1990/rainbow')
  "call packager#add('RRethy/vim-hexokinase', {'do': 'make hexokinase'})
  call packager#add('norcalli/nvim-colorizer.lua')

  " }}}

  " {{{ Interfaces

  " Fzf
  call packager#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call packager#add('junegunn/fzf.vim')
  call packager#add('airblade/vim-rooter')

  " Floating terminal
  call packager#add('voldikss/vim-floaterm')

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

  " }}}

  " }}}
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

"Load plugins only for specific filetype
"Note that this should not be done for plugins that handle their loading using ftplugin file.
"More info in :help pack-add
augroup packager_filetype
  autocmd!
  autocmd FileType go packadd vim-go
augroup END
