set termguicolors

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

" Material
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'

" Set color schemes
set background=dark
colorscheme gruvbox
let g:airline_theme = 'gruvbox'

" Color brackets
let g:rainbow_active = 1

" Disable for Pandoc and VimWiki
let g:rainbow_conf = {
  \ 'separately': {
  \   'help': 0,
  \   'LuaTree': 0,
  \   'pandoc': 0,
  \   'vimwiki': 0,
  \   'vue': 0
  \ }
  \}
