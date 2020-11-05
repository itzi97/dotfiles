let g:pandoc#filetypes#handled = ['pandoc', 'markdown', 'rst', 'textile']
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

" Command
let g:pandoc#command#autoexec_on_writes = 0
"let g:pandoc#command#autoexec_command = 'Pandoc pdf'
let g:pandoc#command#custom_open = 'MyPandocOpen'

function! MyPandocOpen(file)
  let file = shellescape(fnamemodify(a:file, ':p'))
  let file_extension = fnamemodify(a:file, ':e')
  if file_extension is? 'pdf'
    if !empty($PDFVIEWER)
      return expand('$PDFVIEWER') . ' ' . file
    elseif executable('evince')
      return 'evince ' . file
    elseif executable('mupdf')
      return 'mupdf ' . file
    elseif executable('zathura')
      return 'zathura ' . file
    endif
  elseif file_extension is? 'html'
    if !empty($BROWSER)
      return expand('$BROWSER') . ' ' . file
    elseif executable('firefox')
      return 'firefox ' . file
    elseif executable('chromium')
      return 'chromium ' . file
    elseif executable('brave')
      return 'brave ' . file
    endif
  elseif file_extension is? 'epub' && executable('zathura')
    return 'zathura ' . file
  else
    return 'xdg-open ' . file
  endif
endfunction

" Use codebraid for codeblocks execution
let g:pandoc#compiler#command = 'codebraid pandoc'
let g:pandoc#compiler#arguments = '--overwrite'

" Biblio sources
let g:pandoc#biblio#sources = 'bclgy'
let g:pandoc#biblio#bibs = [ '/home/itziar/Documents/Notes/global.bib' ]

"augroup pandoc_markdown
"  autocmd BufEnter *.md set filetype=pandoc
"augroup END

augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
