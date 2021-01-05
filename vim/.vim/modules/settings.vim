" Map keys
let mapleader='ñ'
let maplocalleader='º'

" Font
set guifont=Hack\ Nerd\ Font\ 10

" General
set number                    " Show number lines
set relativenumber            " Show number of lines above and below
set textwidth=80 wrap         " Line wrap at 80 characters
set colorcolumn=+1            " Show textwidth
set showbreak=﬌               " Wrap-broken line prefix
set showmatch                 " Highlight matching brace
set foldmethod=marker         " Enable folding by markers
set conceallevel=2            " Prettify code
set scrolloff=5               " Keep 5 lines above or below cursor at all times

" Tabs, spaces and company
set tabstop=2
set softtabstop=2             " Number of spaces per tab
set expandtab                 " Use spaces instead of tabsshiftwidth=2 smarttab
set shiftwidth=2              " Number of auto-indent spaces
set smarttab
set smartindent
set autoindent                " Auto indent new lines
set list

" Prettify
set listchars=tab:»\ ,trail:·,eol:↵,nbsp:⍽

" Cursor shape (changes depending on insert or normal mode)
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Set formatting options
set formatoptions+=t          " Respect textwidth
set formatoptions+=c          " Comments respect textwidth
set formatoptions+=n          " Respect list indents
set formatoptions+=j          " Remote comment leader when joining lines

" Spelling
set nospell                   " Disable by default
"set spelllang=es,en           " English + spanish

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
