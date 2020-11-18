" Linting
let g:ale_lint_on_text_change = 1

let g:ale_linters = {
	\ 'go': ['golint'],
  \ 'pandoc': ['alex', 'languagetool', 'redpen'],
  \ 'tex': ['lacheck'],
  \ 'vim': ['vint'],
  \ 'vue': ['eslint', 'vls'],
  \ 'zsh': ['shell']
  \}

" Only run specified linters
let g:ale_linters_explicit = 1

" ALE completion is not loaded but can be used for other plugins
let g:ale_completion_autoimport = 1

" Disable fixing
let g:ale_fix_on_save = 0

" Disable LSP
let g:ale_disable_lsp = 1

" Column symbols
let g:ale_sign_column_always = 1
let g:ale_sign_error = ' '
let g:ale_sign_warning = '𥉉'

" Disable trailing whitespace warnings (NeoFormat handles them)
let g:ale_warn_about_trailing_whitespace = 0

" Change message format
let g:ale_echo_msg_error_str = ' '
let g:ale_echo_msg_warning_str = '𥉉'
let g:ale_echo_msg_format = '[%severity%%linter%] %s'

" Set keys to navigate between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
