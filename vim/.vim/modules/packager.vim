" {{{ Auto Intallation

packadd vim-packager

if !exists('g:loaded_vim_packager')

  let s:packager_repo = 'https://github.com/kristijanhusak/vim-packager'
  let s:packager_dir_vim = '~/.vim/pack/packager/opt/vim-packager'
  let s:packager_dir_nvim = '~/.config/nvim/pack/packager/opt/vim-packager'

  " Install vim packager if not installed
  if has('nvim')
    execute '!git clone ' . s:packager_repo . ' ' . s:packager_dir_nvim
  else
    execute '!git clone ' . s:packager_repo . ' ' . s:packager_dir_vim
  endif

endif

" }}}

function! PackagerInit() abort

  " {{{ Init

  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })

  " }}}

  " {{{ Intellisense

  " LSP + Asyncomplete
  if has('python3')
    call packager#add('prabirshrestha/vim-lsp')
    call packager#add('mattn/vim-lsp-settings')
    call packager#add('prabirshrestha/asyncomplete.vim')
    call packager#add('prabirshrestha/asyncomplete-lsp.vim')

    " Sources
    call packager#add('prabirshrestha/asyncomplete-file.vim')
    call packager#add('prabirshrestha/asyncomplete-buffer.vim')
    call packager#add('yami-beta/asyncomplete-omni.vim')

    " Ultisnips
    call packager#add('SirVer/ultisnips')
    call packager#add('thomasfaingnaert/vim-lsp-snippets')
    call packager#add('thomasfaingnaert/vim-lsp-ultisnips')
    call packager#add('honza/vim-snippets')
    call packager#add('prabirshrestha/asyncomplete-ultisnips.vim')
  endif

  " Linting
  call packager#add('dense-analysis/ale')

  " Auto formatting (until vim-lsp supports more types)
  call packager#add('sbdchd/neoformat')

  " }}}

  " {{{ Misc

  " Change surrounding delimiters
  call packager#add('tpope/vim-surround')

  " Nice auto commenting
  call packager#add('preservim/nerdcommenter')

  " Exchange words (foo bar -> bar foo)
  call packager#add('tommcdo/vim-exchange')

  " Discord RPC
  if has('nvim')
    call packager#add('aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'})
  else
    call packager#add('hugolgst/vimsence')
  endif

  " }}}

  " {{{ Language Support

  call packager#add('sheerun/vim-polyglot')

  " Go
  call packager#add('fatih/vim-go', { 'do': ':GoInstallBinaries', 'type': 'opt' })

  " Markdown, RMarkdown
  call packager#add('vim-pandoc/vim-pandoc')
  call packager#add('vim-pandoc/vim-pandoc-syntax')
  call packager#add('vim-pandoc/vim-rmarkdown')

  " LaTeX
  call packager#add('lervag/vimtex')

  " R
  call packager#add('jalvesaq/Nvim-R', {'branch': 'master'})

  " Rust
  call packager#add('rust-lang/rust.vim')

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

  " Fzf
  call packager#add('junegunn/fzf', {
        \ 'do': './install --all && ln -s $(pwd) ~/.fzf'
        \ })
  call packager#add('junegunn/fzf.vim')
  call packager#add('airblade/vim-rooter')

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
  call packager#add('vim-airline/vim-airline')
  call packager#add('vim-airline/vim-airline-themes')

  " NERDTRee
  call packager#add('preservim/nerdtree')
  call packager#add('Xuyuanp/nerdtree-git-plugin')
  call packager#add('tiagofumo/vim-nerdtree-syntax-highlight')

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
