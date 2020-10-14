set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

" Airline integration
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = ' :'
let g:airline#extensions#nvimlsp#warning_symbol = ' :'

" Extensions
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
  \ :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText" }

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})

" Deoplete as completion
packadd deoplete.nvim
let g:deoplete#enable_at_startup = 1

" Add vimtex as completion source
packadd vimtex
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})

" Add pandoc as completion source
packadd vim-pandoc
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'pandoc': '@'
  \})

" Ultisnips as snippet completion
let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-j>"
