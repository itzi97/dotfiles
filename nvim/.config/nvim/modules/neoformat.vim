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