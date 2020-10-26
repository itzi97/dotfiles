let g:tex_flavor = 'latex'
let g:tex_conceal = ''

let g:vimtex_complete_recursive_bib = 1
let g:vimtex_complete_enabled = 1

" Viewer
let g:vimtex_view_general_viewer = 'evince'
let g:vimtex_view_forward_search_on_start = 0

" Use lualatex by default
let g:vimtex_compiler_latexmk_engines = {
  \ '_'                : '-xelatex',
  \}

let g:vimtex_compiler_latexmk = {
  \ 'options' : [
  \   '-verbose',
  \   '-file-line-error',
  \   '-synctex=1',
  \   '-interaction=nonstopmode',
  \   '--shell-escape'
  \ ],
  \}
