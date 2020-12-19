if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE

  " Needed for kitty terminal background rendering
  if !has('nvim')
    let &t_ut=''
  endif
endif

set background=dark

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'

" Material
let g:material_theme_style = 'darker'
let g:material_terminal_italics = 1

" NVCode
let g:nvcode_termcolors=256

" Set colorscheme
if has('nvim')
  " luafile ~/.config/nvim/lua/conf_treesitter.lua
  colorscheme iceberg
  let g:airline_theme = 'iceberg'
  "colorscheme nvcode
  "let g:airline_theme = 'minimalist'
else
  colorscheme nord
  let g:airline_theme = 'nord'
endif
