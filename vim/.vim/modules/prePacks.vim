" Not compatible with vi
if !has('nvim') && &compatible
  set nocompatible
endif

" Disable specific polyglot languages
let g:polyglot_disabled = [
      \ 'go',
      \ 'vim',
      \ 'tex',
      \ 'markdown',
      \ 'pandoc',
      \ 'rust'
      \]
