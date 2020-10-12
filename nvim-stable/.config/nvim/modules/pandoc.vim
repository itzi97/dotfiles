let g:pandoc#filetypes#handled = ['pandoc', 'markdown']
let g:pandoc#filetypes#pandoc_markdown = 1
let g:pandoc#formatting#mode = 'sA'
let g:pandoc#formatting#textwidth = 99

let g:pandoc#biblio#sources = 'bclgy'
let g:pandoc#biblio#bibs = [
      \ '/home/itziar/Documents/Notes/global.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S1/libros.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S2/libros.bib',
      \ '/home/itziar/Documents/Notes/UTAD/S3/libros.bib'
      \ ]
