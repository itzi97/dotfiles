" Enable linting
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

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 0

" Airline with ale
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = ' :'
let g:airline#extensions#ale#warning_symbol = ' :'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = ' :'
let g:airline#extensions#ale#close_lnum_symbol = ''

" Keep sign gutter open
let g:ale_sign_column_always = 1

" Customize signs
let g:ale_sign_error = ' '
let g:ale_sign_warning = ' '

" Navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
