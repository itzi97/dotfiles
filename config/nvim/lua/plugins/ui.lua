-- Colourscheme, statusline, and the two mini.nvim modules that earn their keep.

return {
  {
    -- gruvbox, dark. ellisonleao's is the maintained Lua port — the original
    -- morhetz/gruvbox is vimscript and no longer the one to use.
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000, -- must load before everything else, or other plugins
                     -- register highlights against the wrong palette
    config = function()
      require("gruvbox").setup({
        -- "hard" | "medium" | "soft". medium is gruvbox as most people picture
        -- it; hard is a darker background, worth trying on a bright day.
        contrast = "medium",
        italic = { strings = false, comments = true },
        -- Dim inactive splits so it's obvious which one has focus.
        dim_inactive = true,
        transparent_mode = false,
      })
      vim.o.background = "dark"
      vim.cmd.colorscheme("gruvbox")
    end,
  },

  {
    -- which-key: shows what the pending key sequence can become. This is the
    -- plugin that makes a hand-rolled config learnable — you don't have to
    -- remember your own leader maps, you just press <leader> and read.
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { delay = 400 },
  },

  {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
      -- Statusline: one small module instead of a separate plugin with its
      -- own config language. It picks up the colourscheme automatically.
      require("mini.statusline").setup({ use_icons = false })

      -- ai: makes `ci(`, `da"` etc. work on *any* treesitter node, so you get
      -- "change inside function" and "delete around class" for free.
      require("mini.ai").setup({ n_lines = 500 })

      -- surround: sa/sd/sr to add, delete, replace surrounding quotes and
      -- brackets. Constant use when writing LaTeX and markdown.
      require("mini.surround").setup()
    end,
  },
}
