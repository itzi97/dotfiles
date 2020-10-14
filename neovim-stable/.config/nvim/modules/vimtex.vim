let g:tex_flavor = 'latex'
let g:tex_conceal = ''

" Use this alongside neovim
let g:vimtex_compiler_progname = 'nvr'

" Completion
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_complete_enabled = 1

let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_view_forward_search_on_start = 1

" Use lualatex by default
let g:vimtex_compiler_latexmk_engines = {
  \ '_'                : '-lualatex',
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
  \   '-synctex=1'
  \ ],
  \}
