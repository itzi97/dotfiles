-- Language servers.
--
-- Two deliberate choices here:
--
-- 1. Servers are installed by mason into ~/.local/share/nvim/mason, NOT by dnf.
--    That keeps the Fedora host clean, which is the whole point of ADR-0012 —
--    and unlike the uni container, these are editor tooling rather than a
--    toolchain, so they belong to neovim rather than to a box.
--
-- 2. Enabling uses vim.lsp.enable(), the API built into Neovim 0.11+, rather
--    than lspconfig's setup() calls. nvim-lspconfig now ships plain config
--    files that the native loader reads. You're on 0.12.4; using the native
--    path means one less layer that can break on a Neovim release — which is
--    exactly how LunarVim ended (ADR-0009).

return {
  {
    -- Mason gets its own spec rather than riding along as a dependency of
    -- lspconfig. As a dependency it only loaded when lspconfig did (on
    -- BufReadPre), so `:Mason` didn't exist in an empty editor — which is
    -- exactly when you want it, since installing servers is the first thing
    -- you do on a fresh machine.
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall", "MasonLog" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-org/mason.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Servers to enable. Install them with :Mason (or :MasonInstall <name>).
      -- Deliberately short — see neovim-config-comparison.md: a grab-bag of
      -- servers you don't use is startup cost and noise.
      --   lua_ls        this config
      --   pyright       coursework Python
      --   clangd        C/C++ engine work
      --   texlab        LaTeX — the CV and reports
      --   marksman      markdown, for the Space documents
      vim.lsp.enable({ "lua_ls", "pyright", "clangd", "texlab", "marksman" })

      -- Keymaps are set on attach rather than globally, so they only exist in
      -- buffers that actually have a server. Pressing gd in a file with no LSP
      -- should do nothing rather than throw.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("grn", vim.lsp.buf.rename, "Rename")
          map("gra", vim.lsp.buf.code_action, "Code action")
          map("grr", vim.lsp.buf.references, "References")
          map("gri", vim.lsp.buf.implementation, "Implementation")
          map("grd", vim.lsp.buf.definition, "Definition")
          map("K", vim.lsp.buf.hover, "Hover docs")

          -- Highlight other references to the symbol under the cursor, and
          -- clear them on move. Guarded: not every server supports it.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight") then
            local hl = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf, group = hl, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf, group = hl, callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },
}
