" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

" Airline integration
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = ' '
let g:airline#extensions#nvimlsp#warning_symbol = '𥉉'

augroup neovim_lsp_functions
" Diagnostics
  autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
" Extensions
  autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
    \ :lua require'lsp_extensions'.inlay_hints{
    \   highlight = "Comment",
    \   prefix    = ' » ',
    \   aligned   = true,
    \ }
augroup end

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : '𥉉', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : 'ﬤ ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : 'ﱴ ', 'texthl' : 'LspDiagnosticsHint'})
