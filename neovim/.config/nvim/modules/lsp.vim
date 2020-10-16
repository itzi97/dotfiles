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

" Diagnostics
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_virtual_text_prefix = ' '
call sign_define('LspDiagnosticsErrorSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsError'})
call sign_define('LspDiagnosticsWarningSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsWarning'})
call sign_define('LspDiagnosticsInformationSign', {'text' : ' ', 'texthl' : 'LspDiagnosticsInformation'})
call sign_define('LspDiagnosticsHintSign', {'text' : '﨣', 'texthl' : 'LspDiagnosticsHint'})

" Completion

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Enable snippet usage
let g:completion_enable_snippet = 'vim-vsnip'

" Expand
imap <expr> <C-i>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-i>'
smap <expr> <C-i>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-i>'

" Expand or jump
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" Jump forward or backward
imap <expr> <C-k>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-k>'
smap <expr> <C-k>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<C-k>'
imap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-j>'
smap <expr> <C-j> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<C-j>'

" Select or cut text to use as $TM_SELECTED_TEXT in the next snippet.
" See https://github.com/hrsh7th/vim-vsnip/pull/50
nmap        s   <Plug>(vsnip-select-text)
xmap        s   <Plug>(vsnip-select-text)
nmap        S   <Plug>(vsnip-cut-text)
xmap        S   <Plug>(vsnip-cut-text)

" If you want to use snippet for multiple filetypes, you can `g:vsip_filetypes` for it.
let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

" Enable auto switching between completion sources
let g:completion_auto_change_source = 1

" Load lua source
execute 'luafile' . stdpath('config') . '/lua/plug-completion.lua'

" Set sources for tex documents
let g:completion_chain_complete_list = {
  \ 'default' : [
  \   {'complete_items': ['lsp', 'ts', 'snippet', 'tabnine']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \   {'complete_items': ['buffer']},
  \   {'mode': '<c-p>'},
  \   {'mode': '<c-n>'}
  \ ],
  \ 'tex' : [
  \   {'complete_items': ['vimtex', 'lsp', 'snippet']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \   {'mode': '<c-p>'},
  \   {'mode': '<c-n>'}
  \ ],
  \ 'pandoc' : [
  \   {'complete_items': ['lsp', 'ts', 'snippet']},
  \   {'complete_items': ['path'], 'triggered_only': ['/']},
  \   {'mode': '<c-p>'},
  \   {'mode': '<c-n>'}
  \ ],
  \}

" Max tabnine completion
let g:completion_tabnine_max_num_results=3

" Use completion-nvim in every buffer
autocmd BufEnter * lua require('completion').on_attach()
