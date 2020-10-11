execute 'luafile ' . stdpath('config') . '/lua/plugins.lua'

command! PackerInstall packadd packer.nvim | lua require('plugins').install()
command! PackerUpdate packadd packer.nvim  | lua require('plugins').update()
command! PackerSync packadd packer.nvim    | lua require('plugins').sync()
command! PackerClean packadd packer.nvim   | lua require('plugins').clean()
command! PackerCompile packadd packer.nvim | lua require('plugins').compile()

syntax on
filetype plugin indent on
