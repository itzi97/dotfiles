" Enable powerline symbols
let g:airline_powerline_fonts= 1

" Automatically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" Powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" Enable plugins
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#vimtex#enabled = 1

" Ale
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = 'E:'
let g:airline#extensions#ale#warning_symbol = 'W:'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = '(L'
let g:airline#extensions#ale#close_lnum_symbol = ')'

" NVIM LSP
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = 'E:'
let g:airline#extensions#nvimlsp#warning_symbol = 'W:'

" Theme
let g:airline_theme='minimalist'
