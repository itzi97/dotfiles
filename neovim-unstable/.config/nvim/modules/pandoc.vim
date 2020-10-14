let g:pandoc#filetypes#handled = ['pandoc', 'markdown']
let g:pandoc#filetypes#pandoc_markdown = 1
let g:pandoc#formatting#mode = 'sA'
let g:pandoc#formatting#textwidth = 99

let g:pandoc#syntax#conceal#blacklist = ['list']

"let g:pandoc#command#custom_open = "zathura"
"let g:pandoc#command#autoexec_on_writes = 1
"let g:pandoc#command#autoexec_command = 'Pandoc pdf'

let g:pandoc#biblio#sources = 'bclgy'
let g:pandoc#biblio#bibs = [ '/home/itziar/Documents/Notes/global.bib' ]
