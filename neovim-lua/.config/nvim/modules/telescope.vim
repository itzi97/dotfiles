execute 'luafile' . stdpath('config') . '/lua/plug-telescope.lua'

nnoremap <Leader>p <cmd>lua require'telescope.builtin'.git_files{}<CR>
