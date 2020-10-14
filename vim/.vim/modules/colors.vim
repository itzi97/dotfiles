if (has('termguicolors'))
  set termguicolors
endif

set background=dark

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" Material
let g:material_terminal_italics = 1
let g:material_theme_style = 'lighter'

" Configure airline theme
colorscheme material
let g:airline_theme = 'material'
