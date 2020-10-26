" Show modified and untracked git files

" returns all modified files of the current git repo
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
  let files = systemlist('git ls-files -m 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" same as above, but show untracked files, honouring .gitignore
function! s:gitUntracked()
  let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
  return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   MRU']            },
  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
  \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]

let g:startify_session_dir = '~/.vim/session'

let g:startify_bookmarks = [
  \ { 'v': '~/.vimrc'},
  \ { 'k': '~/.config/kitty/kitty.conf'},
  \ { 'x': '~/.xmonad/xmonad.hs'},
  \ '~/Documents/UTAD/Proyectos-2/1-Inteniería-Datos',
  \ '~/Documents/UTAD/Proyectos-3',
  \ '~/Documents/UTAD/Semestre-03/Álgebra-Lineal',
  \ '~/Documents/UTAD/Semestre-03/Análisis-Matemático-I',
  \ '~/Documents/UTAD/Semestre-03/Programación-Web-I-Cliente',
  \]

" Prepend icons to each startify entry
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
