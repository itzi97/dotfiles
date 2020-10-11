-- Load Lua plugins.
vim.cmd [[packadd nvim-lsp]]
vim.cmd [[packadd nvim-lspconfig]]
vim.cmd [[packadd diagnostic-nvim]]
vim.cmd [[packadd completion-nvim]]

local completion = require("completion")
local diagnostic = require("diagnostic")

completion.addCompletionSource("vimtex", require("vimtex").complete_item)

local chain_complete_list = {
  default = {
    {complete_items = {"lsp", "ts", "snippet"}},
    {complete_items = {"path"}, triggered_only = {"/"}},
    {complete_items = {"buffers"}},
    {mode = "<c-p>"},
    {mode = "<c-n>"}
  },
  string = {{complete_items = {"path"}, triggered_only = {"/"}}},
  comment = {},
  tex = {{complete_items = {"vimtex", "lsp"}, triggered_only = {"\\"}}}
}

-- Configure completion for all buffers (even if they don't have lsp)
vim.cmd [[ augroup LspCompletion ]]
vim.cmd [[ au BufEnter * lua require('completion').on_attach() ]]
vim.cmd [[ augroup END ]]
completion.on_attach({
  sorting = "alphabet",
  matching_strategy_list = {"exact", "fuzzy"},
  -- enable_auto_signature = 1,
  auto_change_source = 1,
  chain_complete_list = chain_complete_list
})
vim.cmd [[ doautoall FileType ]]

-- Attatch diagnostics to every language server
local on_attach_fun = function()
  diagnostic.on_attach()
end

-- Configure language servers in Lua.
local nvim_lsp = require("nvim_lsp")

-- Bash
nvim_lsp.bashls.setup {filetypes = {"sh", "zsh", "bash"}, on_attach = on_attach_fun}

-- C/C++
nvim_lsp.ccls.setup {on_attach = on_attach_fun}
nvim_lsp.clangd.setup {on_attach = on_attach_fun}

-- CMake
nvim_lsp.cmake.setup {on_attach = on_attach_fun}

-- Diagnostics
nvim_lsp.diagnosticls.setup {filetypes = {"sh", "zsh", "md", "plain"}, on_attach = on_attach_fun}

-- CSS
nvim_lsp.cssls.setup {on_attach = on_attach_fun}

-- Go
nvim_lsp.gopls.setup {on_attach = on_attach_fun}

-- Haskell
nvim_lsp.hls.setup {on_attach = on_attach_fun}

-- Html
nvim_lsp.html.setup {on_attach = on_attach_fun}

-- Java
nvim_lsp.jdtls.setup {on_attach = on_attach_fun}

-- JavaScript
nvim_lsp.flow.setup {on_attach = on_attach_fun}
nvim_lsp.tsserver.setup {on_attach = on_attach_fun}

-- Julia
nvim_lsp.julials.setup {on_attach = on_attach_fun}

-- TODO LaTeX
nvim_lsp.texlab.setup {
  settings = {
    latex = {
      build = {
        args = {
          "-pdf",
          "lualatex",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-pdflualatex='lualatex --shell-escape --output-format=pdf'"
        },
        executable = "latexmk",
        onSave = true
      }
    }
  },
  on_attach = on_attach_fun
}

-- Lua
nvim_lsp.sumneko_lua.setup {on_attach = on_attach_fun}

-- Nix
nvim_lsp.rnix.setup {on_attach = on_attach_fun}

-- PHP
nvim_lsp.intelephense.setup {on_attach = on_attach_fun}

-- Python
nvim_lsp.pyls.setup {on_attach = on_attach_fun}

-- R
nvim_lsp.r_language_server.setup {on_attach = on_attach_fun}

-- Rust
nvim_lsp.rls.setup {on_attach = on_attach_fun}
nvim_lsp.rust_analyzer.setup {on_attach = on_attach_fun}

-- SQL
nvim_lsp.sqlls.setup {on_attach = on_attach_fun}

-- Vim
nvim_lsp.vimls.setup {on_attach = on_attach_fun}

-- Attatch functions for autocomplete and formatting.
vim.cmd [[autocmd Filetype * setlocal omnifunc=v:lua.vim.lsp.omnifunc]]
vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
