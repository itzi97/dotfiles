--vim.cmd('packadd nvim-lspconfig')

-- Configure language servers in Lua.
local nvim_lsp = require('nvim_lsp')

-- Bash
nvim_lsp.bashls.setup{on_attach=require'diagnostic'.on_attach}

-- C/C++
nvim_lsp.ccls.setup{on_attach=require'diagnostic'.on_attach}
nvim_lsp.clangd.setup{on_attach=require'diagnostic'.on_attach}

-- CMake
nvim_lsp.cmake.setup{on_attach=require'diagnostic'.on_attach}

-- CSS
nvim_lsp.cssls.setup{on_attach=require'diagnostic'.on_attach}

-- Go
nvim_lsp.gopls.setup{on_attach=require'diagnostic'.on_attach}

-- Haskell
nvim_lsp.hls.setup{on_attach=require'diagnostic'.on_attach}

-- Html
nvim_lsp.html.setup{on_attach=require'diagnostic'.on_attach}

-- Java
nvim_lsp.jdtls.setup{on_attach=require'diagnostic'.on_attach}

-- JavaScript
nvim_lsp.tsserver.setup{on_attach=require'diagnostic'.on_attach}

-- Julia
nvim_lsp.julials.setup{on_attach=require'diagnostic'.on_attach}

-- LaTeX
nvim_lsp.texlab.setup{on_attach=require'diagnostic'.on_attach}

-- Lua
nvim_lsp.sumneko_lua.setup{on_attach=require'diagnostic'.on_attach}

-- Nix
nvim_lsp.rnix.setup{on_attach=require'diagnostic'.on_attach}

-- PHP
nvim_lsp.intelephense.setup{on_attach=require'diagnostic'.on_attach}

-- Python
nvim_lsp.pyls.setup{on_attach=require'diagnostic'.on_attach}

-- R
nvim_lsp.r_language_server.setup{on_attach=require'diagnostic'.on_attach}

-- Rust
nvim_lsp.rls.setup{on_attach=require'diagnostic'.on_attach}
nvim_lsp.rust_analyzer.setup{on_attach=require'diagnostic'.on_attach}

-- SQL
nvim_lsp.sqlls.setup{on_attach=require'diagnostic'.on_attach}

-- Vim
nvim_lsp.vimls.setup{on_attach=require'diagnostic'.on_attach}
