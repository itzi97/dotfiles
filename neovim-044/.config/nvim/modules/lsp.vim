" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

" Extensions
augroup lsp_extensions
  autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs lua require'plug-lsp_extensions'
augroup end

" Diagnostics
augroup lsp_diagnostics
  autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
augroup end

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : '𥉉', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : 'ﬤ ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : 'ﱴ ', 'texthl' : 'LspDiagnosticsHint'})

" Completion

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Enable snippet usage
packadd UltiSnips
let g:completion_enable_snippet = 'UltiSnips'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<c-w>"
let g:UltiSnipsJumpForwardTrigger="<c-w>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" Enable auto switching between completion sources
let g:completion_auto_change_source = 1

" Load lua source
execute 'luafile' . stdpath('config') . '/lua/plug-completion.lua'

" Set sources for tex documents
let g:completion_chain_complete_list = {
  \ 'default' : [
  \   {'complete_items': ['lsp', 'ale', 'ts', 'snippet', 'tabnine']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \   {'complete_items': ['buffer']},
  \   {'mode': '<c-p>'},
  \   {'mode': '<c-n>'}
  \ ],
  \ 'tex' : [
  \   {'complete_items': ['vimtex', 'lsp', 'snippet']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \ ],
  \ 'pandoc' : [
  \   {'complete_items': ['pandoc', 'lsp', 'ts', 'snippet']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \ ],
  \}

" Max tabnine completion
let g:completion_tabnine_max_num_results=3

" Matching strategies
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

" Trigger on delete
let g:completion_trigger_on_delete = 1
