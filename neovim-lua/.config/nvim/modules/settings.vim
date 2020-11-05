" Set encoding
set encoding=utf-8
set fileencoding=utf-8
scriptencoding utf-8

" Map keys
let mapleader='ñ'
let maplocalleader='º'

" Font
set guifont=Hack\ Nerd\ Font\ 10

" General
set number                    " Show number lines
set relativenumber            " Show number of lines above and below
set textwidth=80 wrap         " Line wrap at 80 characters
set showbreak=﬌               " Wrap-broken line prefix
set showmatch                 " Highlight matching brace
set foldmethod=marker         " Enable folding by markers
set conceallevel=2            " Prettify code
set scrolloff=7               " Show 7 lines above or below when scrolling
set fileformat=unix

" Tabs, spaces and company
set tabstop=8                 " Tab size
set softtabstop=2             " Number of spaces per tab
set expandtab                 " Use spaces instead of tabsshiftwidth=2 smarttab
set shiftwidth=2              " Number of auto-indent spaces
set smartindent
set smarttab
set autoindent                " Auto indent new lines

" Prettify
set list
set listchars=tab:»\ ,trail:·,eol:↵,nbsp:⍽
set fillchars=eob:·

" Set formatting options
set formatoptions+=t          " Respect text width
set formatoptions+=c          " Comments respect text width
set formatoptions+=n          " Respect list indents
set formatoptions+=j          " Remote comment leader when joining lines

" Spelling
set nospell                   " Disable by default
set spelllang=en_us,es        " English + Spanish

" Text edit might fail if hidden is not set
set hidden

" Always show sign column
set signcolumn=yes

" Give more space for displaying messages.
set cmdheight=2

" Having longer update time (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Turn on the Wild menu
set wildmenu

" Ignore compiled files.
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler
