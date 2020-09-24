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
"
"  General keybinds:
"  ============================================================================

"  ----------------------------------------------------------------------------
"  {{{ PLUGINS
"  ----------------------------------------------------------------------------

" Before loading plugins
let g:ale_disable_lsp = 1
let g:polyglot_disabled = ['markdown']

call plug#begin(stdpath('data').'/plugged')
" {{{ Linting/Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'sirver/UltiSnips'
Plug 'honza/vim-snippets'
Plug 'ludovicchabant/vim-gutentags'
Plug 'tpope/vim-surround'
" }}}
" {{{ Misc
Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}
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
" R
Plug 'jalvesaq/Nvim-R', {'branch': 'stable'}
" Viml
Plug 'Shougo/neco-vim'
Plug 'neoclide/coc-neco'
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
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
" }}}
call plug#end()

syntax on
filetype plugin indent on

" Enable deoplete for completion
let g:deoplete#enable_at_startup = 1

"  }}} ------------------------------------------------------------------------
"  {{{ GENERAL SETTINGS
"  ----------------------------------------------------------------------------
"  ñ for map leader, º for local map leader
let mapleader='ñ'
let maplocalleader='º'

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

" TextEdit might fail if hidden is not set
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Spansih and english spelling enabled
set spelllang=en,es

set conceallevel=2

" ñl to highlight all lines
nnoremap <silent> <Leader>l
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>'.&tw.'v.\+', -1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>80v.\+', -1) <Bar>
      \ endif<CR>

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

" Replace tabs
set list listchars=tab:▸\ "
"set list listchars=tab:▸\ ,eol:¬

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
"  {{{ ALE & COC
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
    \ 'tex': ['latexindent', 'textlint'],
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

" You should not turn this setting on if you wish to use ALE as a completion
" source for other completion plugins, like Deoplete.
let g:ale_completion_enabled = 0

" ALE provides an omni-completion function you can use for triggering
" completion manually with <C-x><C-o>
set omnifunc=ale#completion#OmniFunc

" ALE supports automatic imports from external modules. This behavior is
" disabled by default and can be enabled by setting:
let g:ale_completion_autoimport = 1

" Use <Tab> and <S-Tab> to navigate the compltion list:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> for confirm completion. You have to remap <cr> to make sure it
" confirms completion when popup menu is visible since default behavior of
" <CR> could be different regard to current completion state and
" completeopt option.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" }}}
" {{{ Signs
" Keep sign gutter open
let g:ale_sign_column_always = 1

" Customize signs
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" }}}
" {{{ Key Bindings
" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)


" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}
" {{{ Functions
" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" }}}
" {{{ Statusline Integration
" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" }}}

"  }}} ------------------------------------------------------------------------
"  {{{ HASKELL
"  ----------------------------------------------------------------------------

"  }}} ------------------------------------------------------------------------
"  {{{ VIMTEX & PANDOC
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
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#formatting#mode = 'hA'
" }}}

"  }}} ------------------------------------------------------------------------
"  {{{ NVIM-R
"  ----------------------------------------------------------------------------
let g:R_assign = ''
let g:R_pdfviewer = 'evince'
"
"  }}} ------------------------------------------------------------------------
"  END OF FILE
"  ============================================================================
