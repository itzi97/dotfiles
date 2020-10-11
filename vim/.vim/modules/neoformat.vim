" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 1

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

" Don't run all formtters, only specified
let g:neoformat_run_all_formatters = 1

" Run on save
augroup fmt
  autocmd!
  autocmd BufWritePre * undojoin | Neoformat
augroup END

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
