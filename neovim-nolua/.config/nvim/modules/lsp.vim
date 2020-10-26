inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode

" Tweak lsp
let g:lsp_signs_error = {'text': ' '}
let g:lsp_signs_warning = {'text': '𥉉'}
let g:lsp_signs_hint = {'text': ' '} "

" Highlight references to the symbol under the cursor.
let g:lsp_highlight_references_enabled = 1

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  " refer to doc to add more commands
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" Format document on save
" Not supported:
" - vim
augroup lsp_format
  autocmd BufWritePre <buffer> LspDocumentFormatSync
augroup END

" Enable vimtex with deoplete
packadd vimtex
packadd deoplete.nvim
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})

" Airline Integration
let g:airline#extensions#lsp#enabled = 1
let g:airline#extensions#lsp#error_symbol = ' '
let g:airline#extensions#lsp#warning_symbol = '𥉉'
let g:airline#extensions#lsp#show_line_numbers = 1
let g:airline#extensions#lsp#open_lnum_symbol = '('
let g:airline#extensions#lsp#close_lnum_symbol = ')'
