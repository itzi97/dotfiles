" {{{ Auto Intallation

let s:packager_repo = 'https://github.com/kristijanhusak/vim-packager'
let s:packager_dir_vim = '~/.vim/pack/packager/opt/vim-packager'
let s:packager_dir_nvim = '~/.config/nvim/pack/packager/opt/vim-packager'

" Install vim packager if not installed
if has('nvim') && !isdirectory(expand(s:packager_dir_nvim))
  execute '!git clone ' . s:packager_repo . ' ' . s:packager_dir_nvim
elseif !has('nvim') && !isdirectory(expand(s:packager_dir_vim))
  execute '!git clone ' . s:packager_repo . ' ' . s:packager_dir_vim
endif

" }}}

function! PackagerInit() abort

  " {{{ Init

  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " }}}

  " {{{ Intellisense

  " LSP + Asyncomplete
  if has('python3')

    " Asymcomplete
    call packager#add('prabirshrestha/asyncomplete.vim', {'requires': [
          \ 'prabirshrestha/asyncomplete-file.vim',
          \ 'prabirshrestha/asyncomplete-buffer.vim',
          \ 'yami-beta/asyncomplete-omni.vim'
          \]})

    " Ultisnips
    call packager#add('SirVer/ultisnips', {'requires': [
          \ 'honza/vim-snippets',
          \ 'prabirshrestha/asyncomplete-ultisnips.vim'
          \]})

    " LSP
    call packager#add('prabirshrestha/vim-lsp', { 'requires': [
          \ 'mattn/vim-lsp-settings',
          \ 'prabirshrestha/asyncomplete-lsp.vim',
          \ 'thomasfaingnaert/vim-lsp-snippets',
          \ 'thomasfaingnaert/vim-lsp-ultisnips'
          \]})
  endif


  " Auto formatting (until vim-lsp supports more types)
  call packager#add('sbdchd/neoformat')

  " }}}

  " {{{ Misc

  " Nice auto commenting
  call packager#add('preservim/nerdcommenter')

  " Spelling
  "call packager#add('git@github.com:itzi97/auto-spell.vim.git')

  " }}}

  " {{{ Language Support

  call packager#add('sheerun/vim-polyglot')

  " Go
  call packager#add('fatih/vim-go', {
        \ 'do': ':GoInstallBinaries',
        \ 'type': 'opt'
        \ })

  " Markdown, RMarkdown
  call packager#add('vim-pandoc/vim-pandoc', { 'requires': [
        \ 'vim-pandoc/vim-pandoc-syntax',
        \ 'vim-pandoc/vim-rmarkdown'
        \]})

  " LaTeX
  call packager#add('lervag/vimtex')

  " R
  call packager#add('jalvesaq/Nvim-R', {'branch': 'master'})

  " }}}

  " {{{ Colors

  " Colorscheme + eyecandy
  call packager#add('morhetz/gruvbox')

  " Eyecandy
  call packager#add('Yggdroot/indentLine')
  call packager#add('rrethy/vim-hexokinase', { 'do': 'make hexokinase' })
  call packager#add('luochen1990/rainbow')

  " }}}

  " {{{ Menus & Interfaces

  " Discord RPC
  call packager#add('hugolgst/vimsence')

  " Fzf
  call packager#add('junegunn/fzf', {
        \ 'do': './install --all && ln -s $(pwd) ~/.fzf',
        \ 'requires': [
        \   'junegunn/fzf.vim',
        \   'airblade/vim-rooter'
        \ ]})

  " Floaterm
  call packager#add('voldikss/vim-floaterm')

  " Git
  call packager#add('tpope/vim-fugitive')
  if has('nvim') || has('patch-8.0.902')
    call packager#add('mhinz/vim-signify')
  else
    call packager#add('mhinz/vim-signify', { 'branch': 'legacy' })
  endif

  " Startify
  call packager#add('mhinz/vim-startify')

  " Airline
  call packager#add('vim-airline/vim-airline', {
        \ 'requires': 'vim-airline/vim-airline-themes'
        \})

  " NERDTRee
  call packager#add('preservim/nerdtree', {'requires': [
        \ 'Xuyuanp/nerdtree-git-plugin',
        \ 'tiagofumo/vim-nerdtree-syntax-highlight'
        \]})

  " Icons
  call packager#add('ryanoasis/vim-devicons')

  " }}}

endfunction

" {{{ Commands

" User commands
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

" }}}
