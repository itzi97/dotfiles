if has('termguicolors')
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
let g:material_theme_style = 'lighter'
let g:material_terminal_italics = 1

" NVCode
let g:nvcode_termcolors=256


" Set colorscheme
if has('nvim')
  " luafile ~/.config/nvim/lua/conf_treesitter.lua
  colorscheme gruvbox
  let g:airline_theme = 'gruvbox'
  "colorscheme nvcode
  "let g:airline_theme = 'minimalist'
else
  colorscheme gruvbox
  let g:airline_theme = 'gruvbox'
endif
