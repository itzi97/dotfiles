set termguicolors

" Ayu
let ayucolor='dark'

" One
let g:one_allow_italics = 1

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" PaperColor
let g:PaperColor_Theme_Options = {
  \ 'theme': {
  \   'default': {
  \     'allow_bold': 1,
  \     'allow_italic': 1
  \     }
  \ },
  \ 'language': {
  \   'python': {
  \     'highlight_builtins' : 1
  \   },
  \   'cpp': {
  \     'highlight_standard_library': 1
  \   },
  \   'c': {
  \    'highlight_builtins' : 1
  \   }
  \ }}

" Molokai
let g:rehash256 = 1

" Set color schemes
set background=dark
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

" Color brackets
let g:rainbow_active = 1
