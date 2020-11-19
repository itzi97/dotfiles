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

" Set colorscheme
colorscheme gruvbox
if filereadable($HOME . '/.vim/modules/airline.vim')
  " Configure airline theme
  let g:airline_theme = 'gruvbox'
endif
