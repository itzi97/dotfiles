let g:vimwiki_list = [{
  \ 'path'               : '~/Documents/vimwiki/',
  \ 'path_html'          : '~/Documents/vimwiki/html',
  \ 'auto_export'        : 1,
  \ 'index'              : 'index',
  \ 'syntax'             : 'default',
  \ 'ext'                : '.wiki',
  \ 'links_space_char'   : '_',
  \ 'auto_generate_tags' : 1
  \}]

let g:vimwiki_dir_link = 'index'

nnoremap <leader>ww :VimwikiIndex <cr>
