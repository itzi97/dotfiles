-- Load Lua plugins.
-- vim.cmd("packadd nvim-lsp")
-- vim.cmd("packadd nvim-lspconfig")
-- vim.cmd("packadd diagnostic-nvim")
-- Configure language servers in Lua.
local nvim_lsp = require("nvim_lsp")
local on_attach_vim = function(client)
  -- require'completion'.on_attach(client)
  require("diagnostic").on_attach(client)
end

-- Bash
nvim_lsp.bashls.setup {on_attach = on_attach_vim}

-- C/C++
nvim_lsp.ccls.setup {on_attach = on_attach_vim}
nvim_lsp.clangd.setup {on_attach = on_attach_vim}

-- CMake
nvim_lsp.cmake.setup {on_attach = on_attach_vim}

-- CSS
nvim_lsp.cssls.setup {on_attach = on_attach_vim}

-- Go
nvim_lsp.gopls.setup {on_attach = on_attach_vim}

-- Haskell
nvim_lsp.hls.setup {on_attach = on_attach_vim}

-- Html
nvim_lsp.html.setup {on_attach = on_attach_vim}

-- Java
nvim_lsp.jdtls.setup {on_attach = on_attach_vim}

-- JavaScript
nvim_lsp.tsserver.setup {on_attach = on_attach_vim}

-- Julia
nvim_lsp.julials.setup {on_attach = on_attach_vim}

-- TODO LaTeX
nvim_lsp.texlab.setup {
  cmd = {"/home/itziar/.cargo/bin/texlab"},
  filetypes = {"tex", "bib"},
  root_dir = vim.loop.os_homedir,
  log_level = vim.lsp.protocol.MessageType.Log,
  message_level = vim.lsp.protocol.MessageType.Log,
  settings = {
    latex = {
      build = {
        args = {
          "-pdf", "lualatex", "-interaction=nonstopmode", "-synctex=1",
          "-pdflualatex='lualatex --shell-escape --output-format=pdf'"
        },
        executable = "latexmk",
        onSave = false
      },
      forwardSearch = {args = {}, executable = nil, onSave = false},
      lint = {onChange = false}
    },
    bibtex = {formatting = {lineLength = 100}}
  },
  on_attach = on_attach_vim
}

-- Lua
nvim_lsp.sumneko_lua.setup {on_attach = on_attach_vim}

-- Nix
nvim_lsp.rnix.setup {on_attach = on_attach_vim}

-- PHP
nvim_lsp.intelephense.setup {on_attach = on_attach_vim}

-- Python
nvim_lsp.pyls.setup {on_attach = on_attach_vim}

-- R
nvim_lsp.r_language_server.setup {on_attach = on_attach_vim}

-- Rust
nvim_lsp.rls.setup {on_attach = on_attach_vim}
nvim_lsp.rust_analyzer.setup {on_attach = on_attach_vim}

-- SQL
nvim_lsp.sqlls.setup {on_attach = on_attach_vim}

-- Vim
nvim_lsp.vimls.setup {on_attach = on_attach_vim}

-- Treesitter
-- vim.cmd("packadd nvim-treesitter")
-- vim.cmd("packadd completion-treesitter")
require("nvim-treesitter.configs").setup {
  ensure_installed = "all",
  highlight = {enable = true}
}

-- Attaches to every FileType mode
-- vim.cmd("packadd nvim-colorizer.lua")
require("colorizer").setup()
