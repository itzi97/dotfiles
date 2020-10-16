let g:pandoc#filetypes#handled = ['pandoc', 'rst', 'rmarkdown', 'textile']
let g:pandoc#filetypes#pandoc_markdown = 1

" Formatting
let g:pandoc#formatting#mode = 'hA'
let g:pandoc#formatting#textwidth = 100
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1

" Folding
let g:pandoc#folding#fold_yaml = 1

" Spelling
let g:pandoc#spell#enabled = 1
let g:pandoc#spell#default_langs = ['en_us', 'es']

" Biblio sources
let g:pandoc#biblio#sources = 'bclgy'
let g:pandoc#biblio#bibs = [ '/home/itziar/Documents/Notes/global.bib' ]
