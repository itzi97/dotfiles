let g:tex_flavor = 'latex'
let g:tex_conceal='abdmg'

" Use this alongside neovim
let g:vimtex_compiler_progname = 'nvr'

let g:vimtex_quickfix_mode = 0
let g:vimtex_view_method = 'general'
let g:vimtex_view_general_viewer = 'evince'

" Completion
let g:vimtex_complete_recursive_bib = 1
let g:vimtex_complete_enabled = 1

let g:vimtex_compiler_latexmk = {
  \ 'options'    : [
  \   '-verbose',
  \   '-file-line-error',
  \   '-interaction=nonstopmode',
  \   '-synctex=1',
  \   '--shell-escape'
  \ ],
  \}

let g:vimtex_grammar_vlty = {'lt_command': 'languagetool'}
