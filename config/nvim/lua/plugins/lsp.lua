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

      -- COMPLETION CAPABILITIES. This was missing entirely.
      --
      -- blink.cmp does not register these for you. It exports
      -- get_lsp_capabilities() and expects the config to wire it up — there is
      -- no vim.lsp.config('*') call anywhere in its source. Until now every
      -- server was started with Neovim's built-in capabilities, which are not
      -- nothing (snippetSupport, documentationFormat and a two-property
      -- resolveSupport are already there) but are missing what blink adds:
      -- labelDetailsSupport, insertReplaceSupport, completionList.itemDefaults,
      -- contextSupport, and 'documentation' + 'detail' in resolveSupport.
      --
      -- That last pair is the one actually being felt: completion.lua turns
      -- documentation.auto_show on, and without 'documentation' in
      -- resolveSupport a server has no way to send the doc text on resolve, so
      -- the window that pops up is frequently empty. The whole stated reason for
      -- enabling it — seeing the signature in an unfamiliar library — was not
      -- working.
      --
      -- '*' means every client; it is the documented idiom for this (:h
      -- vim.lsp.config). The second argument to get_lsp_capabilities() folds in
      -- nvim's defaults rather than replacing them.
      --
      -- COST: this loads blink at BufReadPre rather than at its own InsertEnter,
      -- because capabilities have to exist before a client starts. Both are
      -- after startup, so `nvim --startuptime` is unaffected. pcall so a blink
      -- that failed to build costs completion quality and not LSP.
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities(nil, true) })
      end

      -- Keymaps are set on attach rather than globally, so they only exist in
      -- buffers that actually have a server. Pressing gd in a file with no LSP
      -- should do nothing rather than throw.
      --
      -- grn / gra / grr / gri USED TO BE MAPPED HERE AND HAVE BEEN REMOVED.
      -- Neovim 0.11 made all four built-in defaults (runtime/lua/vim/
      -- _defaults.lua), mapped unconditionally rather than on attach, so
      -- redeclaring them bought nothing. It also cost something: the copies here
      -- were normal-mode only, and shadowed nvim's gra, which is {n,x} — so
      -- removing them is what gets visual-mode code actions back. gO (document
      -- symbol) and i_CTRL-S (signature help) arrive from the same defaults and
      -- were never declared here at all.
      --
      -- What stays is what nvim does not give you:
      --   grd  not among the 0.11 defaults
      --   K    nvim binds K to hover on attach ONLY if K is otherwise unmapped;
      --        declaring it keeps it on hover rather than 'keywordprg' if
      --        anything else ever claims the key
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
          end

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
