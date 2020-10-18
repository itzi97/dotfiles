" Linting
let g:ale_lint_on_text_change = 1

let g:ale_linters = {
  \ 'pandoc': ['alex', 'languagetool', 'redpen'],
  \ 'tex': ['lacheck', 'languagetool'],
  \ 'vue': ['eslint', 'vls'],
  \ 'zsh': ['shell']
  \}

" ALE completion is not loaded but can be used for other plugins
let g:ale_completion_autoimport = 1

" Only run specified linters
let g:ale_linters_explicit = 1

" Disable fixing
let g:ale_fix_on_save = 0

" Disable LSP
let g:ale_disable_lsp = 1

" Column symbols
let g:ale_sign_column_always = 1
let g:ale_sign_error = ' '
let g:ale_sign_warning = '𥉉'

" Enable Airline integration
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#ale#error_symbol = ' '
let g:airline#extensions#ale#warning_symbol = '𥉉'
let g:airline#extensions#ale#show_line_numbers = 1
let g:airline#extensions#ale#open_lnum_symbol = '('
let g:airline#extensions#ale#close_lnum_symbol = ')'

" Disable trailing whitespace warnings (NeoFormat handles them)
let g:ale_warn_about_trailing_whitespace = 0

" Change message format
let g:ale_echo_msg_error_str = ' '
let g:ale_echo_msg_warning_str = '𥉉'
let g:ale_echo_msg_format = '[%severity%%linter%] %s'

" Set keys to navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
