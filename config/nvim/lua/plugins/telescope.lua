-- Fuzzy finding: files, grep, buffers, help.
--
-- Note what is NOT here: telescope-fzf-native. It's the usual companion and it
-- is genuinely faster, but it has `build = "make"` — and `make` is Tier 3 on
-- this machine, being removed from the host and reached through a wrapper that
-- runs it inside the uni container (ADR-0012). Building a host binary inside a
-- container is the kind of thing that works until it doesn't, on the machine
-- that must not fail during a deadline (principle #2).
--
-- Pure-Lua sorting is slower on very large repos. Coursework repos are not
-- large. If that ever stops being true, add fzf-native then — with a note.

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",   desc = "Grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",     desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Help" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fr", "<cmd>Telescope resume<CR>",      desc = "Resume last search" },
    -- Search this config specifically. Sounds indulgent; it is the single most
    -- used mapping while a hand-rolled config is still being built.
    {
      "<leader>fn",
      function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find in nvim config",
    },
  },
  opts = {
    defaults = {
      -- ripgrep and fd are both installed by bootstrap.sh (common.txt /
      -- fedora.txt), so telescope uses them rather than its slow fallbacks.
      vimgrep_arguments = {
        "rg", "--color=never", "--no-heading", "--with-filename",
        "--line-number", "--column", "--smart-case",
      },
      path_display = { "truncate" },
    },
    pickers = {
      find_files = { hidden = true, find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" } },
    },
  },
}
