" Not compatible with vi
if &compatible
  set nocompatible
endif

" Disable specific polyglot languages
let g:polyglot_disabled = [
      \ 'go',
      \ 'vim',
      \ 'tex',
      \ 'markdown',
      \ 'pandoc'
      \]
