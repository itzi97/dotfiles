packadd asyncomplete.vim
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" Enable preview window
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview

" Auto close window
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" Add file sources
packadd asyncomplete-file.vim
call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

" Add buffer sources
packadd asyncomplete-buffer.vim
call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'allowlist': ['*'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
      \    'max_buffer_size': 5000000,
      \  },
      \ }))

" Add omnifunc sources
packadd asyncomplete-omni.vim
call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
      \ 'name': 'omni',
      \ 'allowlist': ['*'],
      \ 'blocklist': ['c', 'cpp', 'html'],
      \ 'completor': function('asyncomplete#sources#omni#completor'),
      \ 'config': {
      \   'show_source_kind': 1
      \ }
      \ }))

" Add ultisnips sources
packadd asyncomplete-ultisnips.vim
call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
      \ 'name': 'ultisnips',
      \ 'allowlist': ['*'],
      \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
      \ }))

" Add vimtex source
packadd vimtex
call asyncomplete#register_source({
      \ 'name': 'vimtex',
      \ 'allowlist': ['tex'],
      \ 'completor': function('vimtex#complete#omnifunc')
      \})

let g:lsp_signs_enabled = 1           " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor in normal mode

" Tweak lsp
let g:lsp_signs_error = {'text': '✗'}
let g:lsp_signs_warning = {'text': ' '}
let g:lsp_signs_hint = {'text': ' '} "

" Highlight references to the symbol under the cursor.
let g:lsp_highlight_references_enabled = 1

highlight link LspErrorText GruvboxRedSign " requires gruvbox

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

