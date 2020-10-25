" Expand
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <C-w> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-w>'
smap <expr> <C-w> vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-w>'
imap <expr> <C-q> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-b>'
smap <expr> <C-q> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-b>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap  s  <Plug>(vsnip-select-text)
xmap  s  <Plug>(vsnip-select-text)
nmap  S  <Plug>(vsnip-cut-text)
xmap  S  <Plug>(vsnip-cut-text)
