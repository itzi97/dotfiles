" Enable powerline symbols
let g:airline_powerline_fonts= 1

" Automatically display all buffers when there's only one tab open
let g:airline#extensions#tabline#enabled = 1

" Set this for ALE integration. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" Enable plugins
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#nerdtree_statusline = 1
let g:airline#extensions#vimtex#enabled = 1

let g:airline#extensions#lsp#enabled = 1
let airline#extensions#lsp#error_symbol = 'E:'
let airline#extensions#lsp#warning_symbol = 'W:'
let airline#extensions#lsp#show_line_numbers = 1
let airline#extensions#lsp#open_lnum_symbol = '(L'
let airline#extensions#lsp#close_lnum_symbol = ')'
