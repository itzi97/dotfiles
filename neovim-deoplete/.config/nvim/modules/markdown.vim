" 0 Tex  Conceal
let g:tex_conceal = ''

" Previewer
let g:mkdp_auto_start = 0

" Default browser
let g:mkdp_browser = 'firefox'

" Make command available global
let g:mkdp_command_for_global = 1

augroup markdown_func
  autocmd BufEnter *.md nmap <localleader>mp <Plug>MarkdownPreviewToggle
augroup END
