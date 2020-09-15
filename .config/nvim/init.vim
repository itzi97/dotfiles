"  ============================================================================
"   __    _   _______   _____  __      __  _______   __    __
"  |  \  | | | ______| /  _  \ \ \    / / |__   __| |  \  /  |
"  |   \ | | | |_____  | | | |  \ \  / /     | |    |   \/   |
"  | |\ \| | | ______| | | | |   \ \/ /      | |    | |\__/| |
"  | | \   | | |_____  | |_| |    \  /     __| |__  | |    | |
"  |_|  \__| |_______| \_____/     \/     |_______| |_|    |_|

"  MY NEOVIM CONFIG :)
"
"  Mostly used for:
"  - LaTeX
"  - RMarkdown
"  ============================================================================

"  ----------------------------------------------------------------------------
"  {{{ PLUGINS
"  ----------------------------------------------------------------------------

call plug#begin(stdpath('data').'/plugged')

" {{{ Linting/Completion
Plug 'dense-analysis/ale'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" }}}
" {{{ Language Support
Plug 'sheerun/vim-polyglot'
" Haskell
Plug 'neovimhaskell/haskell-vim' " Haskell support should ship with vim
" LaTeX
Plug 'lervag/vimtex'
" Markdown
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" }}}
" {{{ Styling
" Color Themes
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
" Indent Line
Plug 'Yggdroot/indentLine'
" }}}
" {{{ Visuals and Menus
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
" }}}
call plug#end()

syntax on
filetype plugin indent on

"  }}} ------------------------------------------------------------------------
"  {{{ GENERAL SETTINGS
"  ----------------------------------------------------------------------------
" Font
set guifont=VictorMono\ Nerd\ Font

" Number Lines
set number relativenumber

" Define tab as 4 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" Define column width and text wrapping
set textwidth=80 wrap

" Folding
set foldmethod=marker

"  }}} ------------------------------------------------------------------------
"  {{{ COLOR THEMES
"  ----------------------------------------------------------------------------

set termguicolors

" Ayu
let ayucolor="light"

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

" Indent Line
let g:indentLine_char = '¦'
let g:indentLine_first_char = '¦'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1

" Set color schemes
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

"  }}} ------------------------------------------------------------------------
"  {{{ AIRLINE
"  ----------------------------------------------------------------------------
" Enable powerline symbols
let g:airline_powerline_fonts= 1

" Automatically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" Set this for ALE integration. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

"  }}} ------------------------------------------------------------------------
"  {{{ ALE & DEOPLETE
"  ----------------------------------------------------------------------------

" {{{ Fixing
" ALEFix command

" Functions configured with ale_fixers
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'javascript': ['prettier', 'eslint'],
    \ 'haskell': ['stylish-haskell'],
    \ 'sh': ['shfmt'],
    \ 'c': ['clang-format'],
    \ 'cpp': ['clang-format'],
    \ 'go': ['gofmt'],
    \ 'json': ['prettier'],
    \ 'tex': ['redpen', 'proselint'],
    \ 'lua': ['luacheck', 'luac']
    \ }

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1
" }}}
" {{{ Linting
" Keep sign gutter open
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'haskell': ['hie-wrapper --lsp'],
    \ 'sh': ['language_server'],
    \ 'c': ['cppcheck'],
    \ 'cpp': ['cppcheck'],
    \ 'go': ['golint'],
    \ 'json': ['jsonlint'],
    \ 'tex': ['redpen', 'chktex'],
    \ 'lua': ['luacheck', 'luac']
    \ }
" }}}
" {{{ Completion
" Enable deoplete for completion
let g:deoplete#enable_at_startup = 1

" Use ALE and also some plugin 'foobar' as completion sources for all code.
call g:deoplete#custom#option('sources', {
    \ '_': ['ale'],
    \ })

" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 0

" ALE provides an omni-completion function you can use for triggering
" completion manually with <C-x><C-o>
set omnifunc=ale#completion#OmniFunc

" ALE supports automatic imports from external modules. This behavior is
" disabled by default and can be enabled by setting:
let g:ale_completion_autoimport = 1
" }}}
" {{{ Signs
" Keep sign gutter open
let g:ale_sign_column_always = 1

" Customize signs
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
" }}}
" {{{ Key Bindings
" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

"  }}} ------------------------------------------------------------------------
"  {{{ HASKELL
"  ----------------------------------------------------------------------------
" to enable highlighting of `forall`
"let g:haskell_enable_quantification = 1

" to enable highlighting of `mdo` and `rec`
"let g:haskell_enable_recursivedo = 1

" to enable highlighting of `proc`
"let g:haskell_enable_arrowsyntax = 1

" to enable highlighting of `pattern`
"let g:haskell_enable_pattern_synonyms = 1

" to enable highlighting of type roles
"let g:haskell_enable_typeroles = 1

" to enable highlighting of `static`
"let g:haskell_enable_static_pointers = 1

" to enable highlighting of backpack keywords
"let g:haskell_backpack = 1

"  }}} ------------------------------------------------------------------------
"  {{{ VIMTEX
"  ----------------------------------------------------------------------------

"  }}} ------------------------------------------------------------------------
"  END OF FILE
"  ============================================================================
