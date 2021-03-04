" Position + size
let g:floaterm_width=0.85
let g:floaterm_height=0.85
let g:floaterm_position='center'

" Transparency
if has('nvim')
" Set floaterm window's background to none
  hi Floaterm guibg=NONE
" Set floating window border line color to none, and background to none
  hi FloatermBorder guibg=NONE
  let g:floaterm_winblend=10
endif

hi FloatermBorder guifg=#d79921

" Keybinds
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_kill   = '<F11>'
