if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
  hi LineNr ctermbg=NONE guibg=NONE

  " Needed for kitty terminal background rendering
  if !has('nvim')
    let &t_ut=''
  else
    autocmd VimEnter * hi Normal ctermbg=none guibg=none
  endif
endif

set background=dark

" Gruvbox
let g:gruvbox_italic=1
let g:gruvbox_bold=1

let g:gruvbox_contrast_dark='hard'
let g:gruvbox_contrast_light='hard'
let g:gruvbox_transparent_bg=1
let g:gruvbox_guisp_fallback='bg'
let g:gruvbox_invert_indent_guides=1

" Material
let g:material_theme_style = 'lighter'
let g:material_terminal_italics = 1

" NVCode
let g:nvcode_termcolors=256

" Ayu Theme
let g:ayucolor="dark"

"colorscheme $VIM_COLOR_THEME
"let g:airline_theme = $VIM_AIRLINE_THEME

colorscheme ayu
let g:airline_theme = 'minimalist'

"" Set colorscheme
"if has('nvim')
"  " luafile ~/.config/nvim/lua/conf_treesitter.lua
"  colorscheme gruvbox
"  let g:airline_theme = 'gruvbox'
"  "colorscheme nvcode
"  "let g:airline_theme = 'minimalist'
"else
"  colorscheme nord
"  let g:airline_theme = 'nord'
"endif
