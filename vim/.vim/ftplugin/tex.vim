" Limit to 100 columns
set wrap textwidth=120

" Use tabs with size 2 (no spaces)
set tabstop=2 shiftwidth=2 noexpandtab

" Turn on spelling and set it to spanish + english
setlocal spell
call SpellMathES()

" Ale options
let b:ale_warn_about_trailing_blank_lines=1
let b:ale_warn_about_trailing_whitespace=1
