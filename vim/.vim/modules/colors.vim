if (has('termguicolors'))
  set termguicolors

  " Needed for kitty terminal background rendering
  let &t_ut=''
endif

set background=dark

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" Material
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'

" Set colorscheme
colorscheme gruvbox
if filereadable($HOME . '/.vim/modules/airline.vim')
  " Configure airline theme
  let g:airline_theme = 'gruvbox'
endif
