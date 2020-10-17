let g:tex_flavor = 'latex'
let g:tex_conceal='abdmg'

" Use this alongside neovim
let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_quickfix_mode = 0

" Completion
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_complete_enabled = 1

" Viewer
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_forward_search_on_start = 0

" Use lualatex by default
let g:vimtex_compiler_latexmk_engines = {
  \ '_'                : '-xelatex',
  \ 'pdflatex'         : '-pdf',
  \ 'dvipdfex'         : '-pdfdvi',
  \ 'lualatex'         : '-lualatex',
  \ 'xelatex'          : '-xelatex',
  \ 'context (pdftex)' : '-pdf -pdflatex=texexec',
  \ 'context (luatex)' : '-pdf -pdflatex=context',
  \ 'context (xetex)'  : '-pdf -pdflatex=''texexec --xtx''',
  \}

let g:vimtex_compiler_latexmk = {
  \ 'build_dir'  : '',
  \ 'callback'   : 1,
  \ 'continuous' : 1,
  \ 'executable' : 'latexmk',
  \ 'hooks'      : [],
  \ 'options'    : [
  \   '-verbose',
  \   '-file-line-error',
  \   '-interaction=nonstopmode',
  \   '--shell-escape',
  \   '-synctex=1',
  \ ],
  \}
