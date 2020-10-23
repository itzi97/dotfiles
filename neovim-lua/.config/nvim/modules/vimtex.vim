let g:tex_flavor = 'latex'
let g:tex_conceal='abdmg'

" Use this alongside neovim
"let g:vimtex_compiler_progname = 'nvr'

" Completion
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_complete_enabled = 1

" Viewer
let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_forward_search_on_start = 0

" Use xelatex by default
let g:vimtex_compiler_latexmk_engines = {
  \ '_'                : '-xelatex',
  \ 'xelatex'          : '-xelatex',
  \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
  \}

let g:vimtex_compiler_latexmk = {
  \ 'options'    : [
  \   '-verbose',
  \   '-file-line-error',
  \   '-interaction=nonstopmode',
  \   '--shell-escape',
  \   '-synctex=1',
  \ ],
  \}
