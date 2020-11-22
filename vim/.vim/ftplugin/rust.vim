" Tabs, spaces and company
set softtabstop=4             " Number of spaces per tab
set expandtab                 " Use spaces instead of tabsshiftwidth=2 smarttab
set shiftwidth=4              " Number of auto-indent spaces
set smarttab
set smartindent
set autoindent                " Auto indent new lines

" Set textwidth
set textwidth=99
set colorcolumn=+1

" Set commands for cargo
function! CargoBuild() abort
  read execute "!cargo build"
endfunction

function! CargoRun() abort
  read execute "!cargo run"
endfunction

command! CargoBuild call CargoBuild()
command! CargoRun call CargoBuild()
