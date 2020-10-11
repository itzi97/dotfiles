let g:completion_confirm_key = ''
let g:completion_max_items = 30
let g:completion_trigger_on_delete = 1
let g:completion_enable_snippet = 'vim-vsnip'
imap <expr> <Tab> pumvisible() ? "\<c-n>" : (vsnip#available(1) ? '<Plug>(vsnip-expand)' : "\<Tab>")
imap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : "\<C-j>"
smap <expr> <C-j> vsnip#available(1) ? '<Plug>(vsnip-jump-next)' : "\<C-j>"
imap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : "\<C-k>"
smap <expr> <C-k> vsnip#available(-1) ? '<Plug>(vsnip-jump-prev)' : "\<C-k>"

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <silent> <Plug>(ComplCREnd) <cr>
imap <silent><expr> <Plug>ComplCR pumvisible() ? complete_info()['selected'] != -1 ? "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<Plug>(ComplCREnd)"
imap <silent><cr> <Plug>ComplCR<Plug>CloserClose<Plug>DiscretionaryEnd


let g:completion_auto_change_source = 1

let g:completion_chain_complete_list = {
  \ 'default' : {
  \   'default': [
  \       {'complete_items': ['lsp']},
  \       {'mode': '<c-p>'},
  \       {'mode': '<c-n>'},
  \],
  \   'comment': [],
  \   'string' : [
  \       {'complete_items': ['path'], 'triggered_only': ['/']}]
  \},
  \ 'tex': {
  \     'default': [
  \     { 'complete_items': ['lsp'] },
  \     { 'complete_items': ['vimtex'] },
  \     { 'mode': '<c-p>' },
  \     { 'mode': '<c-n>' },
  \],
  \     'comment': [],
  \     'string' : [ {'complete_items': ['path']} ]
  \}}

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

" Trigger characters.
"augroup CompletionTriggerCharacter
"  autocmd!
"  autocmd BufEnter * let g:completion_trigger_character = ['.']
"  autocmd BufEnter *.c,*.cpp let g:completion_trigger_character = ['.', '::']
"  autocmd BufEnter *.tex let g:completion_trigger_character = ['\\', '{']
"augroup end

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})

" Limit tabnine results to 3.
let g:completion_tabnine_max_num_results=3
let g:completion_tabnine_sort_by_details=1
