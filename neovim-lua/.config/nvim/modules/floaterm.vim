" Define size and position
let g:floaterm_width=0.85
let g:floaterm_height=0.85
let g:floaterm_position='center'

" Use transparency if using Neovim
if (has('nvim'))
  let g:floaterm_winblend=10
endif

" Keys
let g:floaterm_keymap_new    = '<F7>'
let g:floaterm_keymap_prev   = '<F8>'
let g:floaterm_keymap_next   = '<F9>'
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_kill   = '<F11>'
