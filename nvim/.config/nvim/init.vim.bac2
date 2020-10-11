"  ============================================================================
"   __    _   _______   _____  __      __  _______   __    __
"  |  \  | | | ______| /  _  \ \ \    / / |__   __| |  \  /  |
"  |   \ | | | |_____  | | | |  \ \  / /     | |    |   \/   |
"  | |\ \| | | ______| | | | |   \ \/ /      | |    | |\__/| |
"  | | \   | | |_____  | |_| |    \  /     __| |__  | |    | |
"  |_|  \__| |_______| \_____/     \/     |_______| |_|    |_|
"
"  MY NEOVIM CONFIG :)
"
"  Mostly used for:
"  - LaTeX
"  - RMarkdown
"  TODO:
"  - Lsp working with: Vimtex, Texlab.
"  ============================================================================

"  ----------------------------------------------------------------------------
"  {{{ PLUGINS
"  ----------------------------------------------------------------------------

" Before loading plugins
"let g:ale_disable_lsp = 0
let g:ale_completion_enabled = 0
let g:polyglot_disabled = ['pandoc', 'markdown', 'tex']

call plug#begin(stdpath('data').'/plugged')

" {{{ Fixing, Linting & Completion
Plug 'dense-analysis/ale'
Plug 'tpope/vim-surround'

" Lsp
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/diagnostic-nvim'

" Lsp completion TODO not working :( with vimtex
"Plug 'nvim-lua/completion-nvim'
"Plug 'steelsojka/completion-buffers'
"Plug 'aca/completion-tabnine', { 'do': './install.sh' }
"Plug 'kristijanhusak/completion-tags'

" Deoplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'Shougo/deoplete-lsp'
Plug 'Shougo/neco-syntax'
let g:deoplete#enable_at_startup = 1

" Snippets
"Plug 'Shougo/neosnippet.vim'
"Plug 'Shougo/neosnippet-snippets'
"Plug 'honza/vim-snippets'

" Fixing
Plug 'sbdchd/neoformat'
" }}}

" {{{ Misc
" Discord Support
Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}
" Git Git Git!
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" Quotes, delimiters, etc.
Plug 'tpope/vim-surround'
" Comments
Plug 'preservim/nerdcommenter'
" Wiki
"Plug 'vimwiki/vimwiki'
" Open file in last place it was edited
Plug 'farmergreg/vim-lastplace'
" Colorizer
Plug 'norcalli/nvim-colorizer.lua'
" Treesitter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/completion-treesitter'
" }}}

" {{{ Language Support
Plug 'sheerun/vim-polyglot'
" C/C++
"Plug 'Shougo/deoplete-clangx'
Plug 'jackguo380/vim-lsp-cxx-highlight'
" Haskell
Plug 'neovimhaskell/haskell-vim' " Haskell support should ship with vim
" Go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'stamblerre/gocode', {
  \ 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
"Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
"Plug 'carlitux/deoplete-ternjs'
Plug 'neovim/node-host', { 'do': 'npm install' }
Plug 'billyvg/tigris.nvim', { 'do': './install.sh' }
" LaTeX
Plug 'lervag/vimtex'
" JSON
Plug 'elzr/vim-json'
" Julia
Plug 'JuliaEditorSupport/julia-vim'
" Markdown
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-rmarkdown'
" Nix
Plug 'LnL7/vim-nix'
" R
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
" Rust
Plug 'rust-lang/rust.vim'
"Plug 'sebastianmarkow/deoplete-rust'
" Python
"Plug 'deoplete-plugins/deoplete-jedi'
"Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
" }}}

" {{{ Styling
" Color Themes
Plug 'ayu-theme/ayu-vim'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tomasr/molokai'
" Indent Line
Plug 'Yggdroot/indentLine'
" }}}

" {{{ Visuals and Menus
" Tree
Plug 'kyazdani42/nvim-web-devicons' " for file icons
Plug 'kyazdani42/nvim-tree.lua'
" Menu
Plug 'mhinz/vim-startify'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
" }}}

call plug#end()

syntax on
filetype plugin indent on

"  }}} ------------------------------------------------------------------------
"  {{{ GENERAL SETTINGS
"  ----------------------------------------------------------------------------
"  ñ for map leader, º for local map leader
let mapleader='ñ'
let maplocalleader='º'

" Font
set guifont=Hack\ Nerd\ Font\ 10

" Number Lines
set number relativenumber

" Define tab as 2 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
set autoindent "Auto indent
set smartindent "Smart indent


" Define column width and text wrapping
set textwidth=80 wrap

" Folding
set foldmethod=marker

" TextEdit might fail if hidden is not set
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Spansih and english spelling enabled.
set spelllang=en,es

" Set conceal level to 2 by default.
set conceallevel=2

" Turn on the Wild menu
set wildmenu

" Ignore compiled files.
set wildignore=*.o,*~,*.pyc

"Always show current position
set ruler

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowritebackup
set noswapfile

" Automatically show long lines on entering file.
augroup ShowLongLinesAuto
  autocmd FileType * call ShowLongLines()
augroup end

function ShowLongLines()
  if &textwidth > 0
    let w:long_line_match = matchadd('ErrorMsg', '\%>'.&textwidth.'v.\+', -1)
  else
    let w:long_line_match = matchadd('ErrorMsg', '\%>80v.\+', -1)
  endif
endfunction

"  }}} ------------------------------------------------------------------------
"  {{{ COLOR THEMES
"  ----------------------------------------------------------------------------

set termguicolors

" Ayu
let ayucolor='dark'

" One
let g:one_allow_italics = 1

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" PaperColor
let g:PaperColor_Theme_Options = {
  \ 'theme': {
  \   'default': {
  \     'allow_bold': 1,
  \     'allow_italic': 1
  \     }
  \ },
  \ 'language': {
  \   'python': {
  \     'highlight_builtins' : 1
  \   },
  \   'cpp': {
  \     'highlight_standard_library': 1
  \   },
  \   'c': {
  \    'highlight_builtins' : 1
  \   }
  \ }}

" Molokai
"let g:molokai_original = 1
let g:rehash256 = 1

" Indent Line
let g:indentLine_char = '¦'
let g:indentLine_first_char = '¦'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_setColors = 1
let g:indentLine_fileTypeExclude = [ 'LuaTree', 'startify', 'tex' ]
let g:indentLine_bufTypeExclude = ['help', 'terminal']


" Replace tabs
"set list listchars=tab:▸\ "↵
set list listchars=tab:»\ ,trail:·,eol:↵,nbsp:⍽

" Set color schemes
set background=dark
colorscheme molokai
let g:airline_theme = 'molokai'

"  }}} ------------------------------------------------------------------------
"  {{{ AIRLINE ----------------------------------------------------------------
" Enable powerline symbols
let g:airline_powerline_fonts= 1

" Automatically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" Set this for ALE integration. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" Tmux
let g:tmuxline_separators = {
      \ 'left' : '',
      \ 'left_alt': '',
      \ 'right' : '',
      \ 'right_alt' : '',
      \ 'space' : ' '}

"  }}} ------------------------------------------------------------------------
"  {{{ VIMTEX & MARKDOWN
"  ----------------------------------------------------------------------------
" {{{ Vimtex
let g:tex_flavor = 'latex'

let g:vimtex_view_general_viewer = 'evince'

" Use lualatex by default
let g:vimtex_compiler_latexmk_engines = {
      \ '_'                : '-lualatex',
      \ 'pdflatex'         : '-pdf',
      \ 'dvipdfex'         : '-pdfdvi',
      \ 'lualatex'         : '-lualatex',
      \ 'xelatex'          : '-xelatex',
      \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
      \ 'context (luatex)' : '-pdf -pdflatex=context',
      \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
      \}

let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \   '--shell-escape'
      \ ],
      \}

" }}}

" {{{ Pandoc
let g:pandoc#filetypes#handled = ['pandoc', 'markdown']
let g:pandoc#filetypes#pandoc_markdown = 1
let g:pandoc#formatting#mode = 'sA'
let g:pandoc#formatting#textwidth = 99

let g:pandoc#biblio#sources = 'bclgy'
let g:pandoc#biblio#bibs = [
      \ '/home/itziar/Documents/Notes/global.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S1/libros.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S2/libros.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S3/libros.bib'
      \ ]
" }}}

"  }}} ------------------------------------------------------------------------
"  {{{ NVIM-R
"  ----------------------------------------------------------------------------

let g:R_assign = ''
let g:R_pdfviewer = 'evince'

"  }}} ------------------------------------------------------------------------
"  {{{ LUA TREE
"  ----------------------------------------------------------------------------
let g:lua_tree_width = 30 " 30 by default
let g:lua_tree_width = 30
let g:lua_tree_auto_close = 1 " Closes the tree when it's the last window
let g:lua_tree_follow = 1 " Cursor updated when following a buffer.
let g:lua_tree_indent_markers = 1
let g:lua_tree_git_hl = 1
let g:lua_tree_root_folder_modifier = ':~'
let g:lua_tree_show_icons = {
  \ 'git': 1,
  \ 'folders': 1,
  \ 'files': 1,
  \}

let g:lua_tree_icons = {
  \ 'default': '',
  \ 'symlink': '',
  \ 'git': {
  \   'unstaged': '✗',
  \   'staged': '✓',
  \   'unmerged': '',
  \   'renamed': '➜',
  \   'untracked': '★'
  \   },
  \ 'folder': {
  \   'default': '',
  \   'open': ''
  \   }
  \ }

nnoremap <C-n> :LuaTreeToggle<CR>
nnoremap <leader>r :LuaTreeRefresh<CR>
nnoremap <leader>n :LuaTreeFindFile<CR>

augroup LuaTreeOverrides
  autocmd!
  autocmd FileType LuaTree setlocal nowrap
augroup end

"  }}} ------------------------------------------------------------------------
"  {{{ ALE, NVIM-LSP
"  ----------------------------------------------------------------------------

" {{{ Fixing

" Enable neoformat fixing.
let g:neoformat_lua_luaformatter = {
  \ 'exe': 'lua-format',
  \ 'args': ['--config=/home/itziar/.config/nvim/formatters/luaformat.yaml'],
  \ 'replace': 0,
  \ 'stdin': 1,
  \ 'env': ['DEBUG=1'],
  \ 'valid_exit_codes': [0, 23],
  \ 'no_append': 1,
  \ }
let g:neoformat_enabled_lua = ['luaformatter']

" Enable alignment globally
let g:neoformat_basic_format_align = 0

" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 0

" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

" Enable ALE fixing.
let g:ale_fixers = {
  \ '*': ['remove_trailing_lines', 'trim_whitespace'],
  \ 'c': ['clang-format'],
  \ 'cpp': ['clang-format'],
  \ 'css': ['prettier'],
  \ 'javascript': ['prettier'],
  \ 'json': ['prettier'],
  \ 'java': ['uncrustify'],
  \ 'haskell': ['stylish-haskell'],
  \ 'html': ['prettier'],
  \ 'go': ['gofmt'],
  \ 'nix': ['nixfmt'],
  \ 'pandoc': ['pandoc'],
  \ 'python': ['yapf'],
  \ 'tex': ['latexindent'],
  \ 'sh': ['shfmt'],
  \ 'xml': ['prettier'],
  \ 'yaml': ['prettier']
  \ }

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" }}}

" {{{ Linting

" Keep sign gutter open
let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'c': ['cppcheck'],
      \ 'cpp': ['cppcheck'],
      \ 'go': ['golint'],
      \ 'json': ['jsonlint'],
      \ 'haskell': ['hie-wrapper --lsp'],
      \ 'sh': ['language_server'],
      \ 'tex': ['lacheck'],
      \ 'vim': ['vint', 'vimls']
      \ }

" }}}

" {{{ Completion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Include lua/init.lua (includes lsp configurationns).
lua require'init'

" Trigger characters.
augroup CompletionTriggerCharacter
  autocmd!
  autocmd BufEnter * let g:completion_trigger_character = ['.']
  autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
augroup end

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})

"lua require'completion'.addCompletionSource('vimtex', require'vimtex'.complete_item)

"let g:completion_chain_complete_list = {
"  \ 'tex' : [
"  \     {'complete_items': ['lsp', 'vimtex']},
"  \   ],
"  \ }
"let g:completion_auto_change_source = 1

" Limit tabnine results to 3.
"let g:completion_tabnine_max_num_results=3
"let g:completion_tabnine_sort_by_details=1
"
augroup NeovimLSP
  autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc
  autocmd Filetype tex setlocal omnifunc=vimtex#complete#omnifunc
"  autocmd BufEnter * lua require'completion'.on_attach()
augroup end

let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = ' :'
let g:airline#extensions#nvimlsp#warning_symbol = ' :'

autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost * :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText" }

" ALE
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = ' :'
let g:airline#extensions#ale#warning_symbol = ' :'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = ' :'
let g:airline#extensions#ale#close_lnum_symbol = ''

" Deoplete
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})
" }}}

" {{{ Signs
" Keep sign gutter open
let g:ale_sign_column_always = 1

" Customize signs
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '
" }}}

" {{{ Key Bindings
" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}

"  }}} ------------------------------------------------------------------------
"  END OF FILE
"  ============================================================================
