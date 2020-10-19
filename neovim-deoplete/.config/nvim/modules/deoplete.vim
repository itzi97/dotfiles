" Enable completion from start
let g:deoplete#enable_at_startup = 1

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Trigger configuration.
let g:UltiSnipsExpandTrigger='<C-w>'
let g:UltiSnipsJumpForwardTrigger='<C-w>'
let g:UltiSnipsJumpBackwardTrigger='<C-b>'

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Options
packadd deoplete.nvim
call deoplete#custom#option({
  \ 'auto_complete_delay': 20,
  \ 'auto_refresh_delay': 100,
  \ 'smart_case': v:true,
  \ })

" Completion sources (uses Ale, LSP, UltiSnips too)
packadd vimtex
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete,
  \ 'pandoc': '@'
  \})

call deoplete#custom#option('omni_patterns', {
  \ 'r': ['[^. *\t]\.\w*', '\h\w*::\w*', '\h\w*\$\w*']
  \})
