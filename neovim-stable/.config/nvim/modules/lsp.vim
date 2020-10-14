set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Source the lua part
execute 'luafile' . stdpath('config') . '/lua/lsp.lua'

" Airline integration
let g:airline#extensions#nvimlsp#enabled = 1
let g:airline#extensions#nvimlsp#error_symbol = ' :'
let g:airline#extensions#nvimlsp#warning_symbol = ' :'

" Extensions
autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
  \ :lua require'lsp_extensions'.inlay_hints{
  \   highlight = "Comment",
  \   prefix    = ' » ',
  \   aligned   = true,
  \ }

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})


" VSNIP snippets

" Expand
imap <expr> <C-i> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '\<C-i>'
smap <expr> <C-i> vsnip#expandable() ? '<Plug>(vsnip-expand)' : '\<C-i>'

" Expand or jump
imap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '\<C-l>'
smap <expr> <C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '\<C-l>'

" Jump forward or backward
imap <expr> <c-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '\<c-j>'
smap <expr> <c-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '\<c-j>'
imap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '\<c-k>'
smap <expr> <c-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '\<c-k>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap s <Plug>(vsnip-select-text)
xmap s <Plug>(vsnip-select-text)
nmap S <Plug>(vsnip-cut-text)
xmap S <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" Deoplete as completion
packadd deoplete.nvim
let g:deoplete#enable_at_startup = 1

" Add vimtex as completion source
packadd vimtex
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'tex': g:vimtex#re#deoplete
  \})

" Add pandoc as completion source
packadd vim-pandoc
call deoplete#custom#var('omni', 'input_patterns', {
  \ 'pandoc': '@'
  \})

" Completion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
