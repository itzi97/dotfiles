-- Git signs in the gutter, plus hunk staging without leaving the buffer.

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "+" },
      change       = { text = "~" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local function map(mode, keys, fn, desc)
        vim.keymap.set(mode, keys, fn, { buffer = bufnr, desc = "Git: " .. desc })
      end

      map("n", "]c", function() gs.nav_hunk("next") end, "Next hunk")
      map("n", "[c", function() gs.nav_hunk("prev") end, "Previous hunk")

      map("n", "<leader>hs", gs.stage_hunk,   "Stage hunk")
      map("n", "<leader>hr", gs.reset_hunk,   "Reset hunk")
      map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
      -- Blame the current line only, in a float. Answers "why is this here"
      -- without a full :Git blame view.
      map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
    end,
  },
}
