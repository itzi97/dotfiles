let g:lua_tree_width = 30 " 30 by default
let g:lua_tree_width = 30
let g:lua_tree_auto_close = 1 " Closes the tree when it's the last window
let g:lua_tree_follow = 1 " Cursor updated when following a buffer.
let g:lua_tree_indent_markers = 1
let g:lua_tree_git_hl = 0
let g:lua_tree_root_folder_modifier = ':~'
let g:lua_tree_show_icons = {
  \ 'git': 1,
  \ 'folders': 1,
  \ 'files': 1,
  \}

let g:lua_tree_icons = {
  \ 'default': '',
  \ 'symlink': '',
  \ 'git': {
  \   'unstaged': '✗',
  \   'staged': '✓',
  \   'unmerged': '',
  \   'renamed': '➜',
  \   'untracked': '★'
  \   },
  \ 'folder': {
  \   'default': '',
  \   'open': ''
  \   }
  \ }

nnoremap <C-n> :LuaTreeToggle<CR>
nnoremap <leader>r :LuaTreeRefresh<CR>
nnoremap <leader>n :LuaTreeFindFile<CR>

augroup LuaTreeOverrides
  autocmd!
  autocmd FileType LuaTree setlocal nowrap
augroup end
