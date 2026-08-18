-- Completion.
--
-- blink.cmp rather than nvim-cmp: far less configuration for the same result,
-- and it's what kickstart moved to. It ships prebuilt binaries, so there's no
-- Rust toolchain requirement — worth checking, since gcc and make are Tier 3
-- and are leaving this host (ADR-0012).
--
-- Failure mode is contained: if the binary can't be fetched, you lose
-- completion, not the editor. That's an acceptable trade on a machine that
-- must not fail during a deadline.

return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*", -- pinned to a major line; lazy-lock.json pins the exact
                   -- commit, and both are committed to git on purpose
  dependencies = { "rafamadriz/friendly-snippets" },

  opts = {
    keymap = {
      -- 'default' is <C-y> to accept, <C-n>/<C-p> to move. Deliberately NOT
      -- <Tab>: Tab is indentation, and in LaTeX especially you want it to
      -- stay indentation rather than sometimes silently accepting a snippet.
      preset = "default",
    },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      -- Show the docs window automatically, after a short pause. The whole
      -- value of LSP completion in an unfamiliar library is the signature.
      documentation = { auto_show = true, auto_show_delay_ms = 300 },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
