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

" Source configuration for completion-nvim
execute 'luafile' . stdpath('config') . '/lua/plug-completion.lua'

" Use completion-nvim for completion
" Trigger characters.
augroup CompletionTriggerCharacter
  autocmd!
  autocmd BufEnter * let g:completion_trigger_character = ['.']
  autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
  autocmd BufEnter *.tex let g:completion_trigger_character = ['\\', '{']
augroup end

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Map <c-p> to manually trigger completion
"imap <silent> <c-p> <Plug>(completion_trigger)

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Enable snippet support
let g:completion_enable_snippet = 'vim-vsnip'

" Use vimtex alongside texlab
let g:completion_chain_complete_list = {
            \ 'tex' : [
            \     {'complete_items': ['vimtex', 'lsp']},
            \   ],
            \ }

" Use completion-nvim in every buffer
autocmd BufEnter * lua require'completion'.on_attach()
