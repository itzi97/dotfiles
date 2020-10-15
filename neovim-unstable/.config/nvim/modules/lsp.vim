" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

" Airline integration
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = ' :'
let g:airline#extensions#nvimlsp#warning_symbol = ' :'

" Extensions
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
  \ :lua require'lsp_extensions'.inlay_hints{
  \   highlight = "Comment",
  \   prefix    = ' » ',
  \   aligned   = true,
  \ }

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})

" Completion

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Enable snippet usage
let g:completion_enable_snippet = 'vim-vsnip'

" Enable auto switching between completion sources
let g:completion_auto_change_source = 1

" Load lua source
execute 'luafile' . stdpath('config') . '/lua/plug-completion.lua'

" Set sources for tex documents
let g:completion_chain_complete_list = {
  \ 'default' : [
  \     {'complete_items': ['lsp', 'ts', 'snippet']},
  \     {'complete_items': ['path'], 'triggered_only': ['/']},
  \     {'complete_items': ['buffers']},
  \     {'mode': '<c-p>'},
  \     {'mode': '<c-n>'}
  \   ],
  \ 'tex' : [
  \     {'complete_items': ['vimtex', 'lsp', 'snippet']},
  \     {'mode': '<c-p>'},
  \     {'mode': '<c-n>'}
  \   ],
  \ 'pandoc' : [
  \     {'complete_items': ['lsp', 'ts', 'snippet']},
  \     {'complete_items': ['pandoc'], 'triggered_only': ['@']},
  \     {'mode': '<c-p>'},
  \     {'mode': '<c-n>'}
  \   ],
  \ }

" Use completion-nvim in every buffer
autocmd BufEnter * lua require('completion').on_attach()
