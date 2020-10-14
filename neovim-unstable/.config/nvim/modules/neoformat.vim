let g:neoformat_lua_luaformatter = {
  \ 'exe': 'lua-format',
  \ 'args': ['--config=/home/itziar/.config/nvim/formatters/luaformat.yaml'],
  \ 'replace': 0,
  \ 'stdin': 1,
  \ 'env': ['DEBUG=1'],
  \ 'valid_exit_codes': [0, 23],
  \ 'no_append': 1,
  \ }
let g:neoformat_enabled_lua = ['luaformatter']

" TODO: Find out how to preserve yaml header using pandoc.
"let g:neoformat_pandoc_pandoc = {
"  \ 'exe': 'pandoc',
"  \ 'args': [
"  \   '--tab-stop=2',
"  \   '--columns=100',
"  \   '--to=markdown'
"  \   ],
"  \ 'stdin': 1,
"  \ 'valid_exit_codes': [0],
"  \}
let g:neoformat_enabled_pandoc = [ ]
let g:neoformat_enabled_markdown = [ ]

"let g:neoformat_cpp_astyle = {
"  \ 'args': [
"  \   '--indent-spaces=2',
"  \   '--style=mozilla'
"  \   ],
"  \ 'stdin': 1,
"  \ 'valid_exit_codes': [0],
"  \}
let g:neoformat_enabled_c   = [ 'astyle' ]
let g:neoformat_enabled_cpp = [ 'astyle' ]

" Enable alignment globally
let g:neoformat_basic_format_align = 0

" Enable tab to spaces conversion globally
let g:neoformat_basic_format_retab = 0

" Enable trimmming of trailing whitespace globally
let g:neoformat_basic_format_trim = 1

augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END
