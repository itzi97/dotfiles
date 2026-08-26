-- Colourscheme, statusline, and the two mini.nvim modules that earn their keep.

-- TWO COLOURSCHEMES, ONE APPLIED. Which one depends on the active Hyprland
-- session theme (ADR-0026) — see lua/config/theme.lua for how that is read.
--
-- Both are lazy = false + priority 1000: a colourscheme has to load before
-- anything that registers highlights, and "the one we're not using" still has
-- to be loaded for a live switch to be instant. Two palettes in memory costs
-- nothing measurable.
--
-- NEITHER SPEC CALLS vim.cmd.colorscheme. If both did, the winner would be
-- whichever lazy.nvim happened to configure last — the same accident-of-order
-- problem the Hyprland config was restructured to avoid. init.lua applies
-- exactly one, once, after both are set up.
return {
  {
    -- gruvbox, dark. ellisonleao's is the maintained Lua port — the original
    -- morhetz/gruvbox is vimscript and no longer the one to use.
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
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
    end,
  },

  {
    -- silkcircuit — the neon-sprawl half. Vivid magenta/cyan on near-black,
    -- which is the whole reason it pairs with that session theme.
    --
    -- NOT PINNED IN lazy-lock.json BY HAND. ADR-0019 keeps that file committed
    -- so plugin versions are reproducible, but the SHA has to come from an
    -- actual fetch — run `:Lazy sync` and commit the resulting diff. A
    -- hand-written SHA would either be wrong or be a guess presented as a pin.
    "hyperb1iss/silkcircuit-nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Guarded: this plugin is newer and less widely used than gruvbox, and
      -- a setup() signature change must not stop the editor from opening.
      -- theme.apply() falls back to gruvbox if the scheme never registers.
      pcall(function()
        require("silkcircuit").setup({})
      end)
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
