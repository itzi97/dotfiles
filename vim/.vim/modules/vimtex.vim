let g:tex_flavor = 'latex'

" Activate certain conceal features
let g:vimtex_syntax_conceal = {
      \ 'accents': 1,
      \ 'greek': 1,
      \ 'math_bounds': 1,
      \ 'math_delimiters': 1,
      \ 'math_super_sub': 1,
      \ 'math_symbols': 1,
      \ 'styles': 1,
      \}

"let g:vimtex_view_method = 'zathura'
"let g:vimtex_view_method = 'mupdf'

let g:vimtex_view_method='zathura'
"let g:vimtex_quickfix_mode=0

"let g:vimtex_view_general_viewer = 'evince'
""let g:vimtex_view_general_viewer = 'zathura'
"let g:vimtex_complete_recursive_bib = 1
"let g:vimtex_complete_enabled = 1
"let g:vimtex_view_forward_search_on_start = 0

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
"
let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \   '--shell-escape'
      \ ],
      \}

      \   " '--shell-escape'

inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
nnoremap <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
