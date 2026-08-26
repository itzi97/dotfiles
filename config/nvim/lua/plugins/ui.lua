-- Colourscheme, statusline, and the two mini.nvim modules that earn their keep.

-- TWO COLOURSCHEMES, ONE APPLIED. Which one depends on the active Hyprland
-- session theme (ADR-0026) — see lua/config/theme.lua for how that is read.
--
-- Both are lazy = false: init.lua calls theme.apply() as soon as
-- require("config.lazy") returns, so both schemes must already be on the
-- runtimepath by then — and "the one we're not using" has to be loaded anyway
-- for a live switch to be instant. Two palettes in memory costs nothing
-- measurable.
--
-- PRIORITY IS NO LONGER A TIE. Both specs carried priority = 1000, which reads
-- like a guarantee about which one wins. It never was one. priority only orders
-- lazy = false plugins among themselves during startup, and since neither spec
-- applies a colourscheme, that order had no observable effect — the duplicate
-- number promised something the config was not doing. The numbers now differ so
-- they encode the preference that is real everywhere else: gruvbox is the safer
-- first paint, and is what both lazy.lua's install.colorscheme and theme.lua's
-- fallback name.
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
    -- PINNED, AS OF 2026-08-26. The note that used to sit here said this was
    -- deliberately unpinned until a real `:Lazy sync` produced a SHA. That sync
    -- has happened: lazy-lock.json carries commit 7d1385d, which is upstream's
    -- current main. Nothing here is hand-written.
    --
    -- Upstream renamed the repo. hyperb1iss/silkcircuit-nvim and
    -- hyperb1iss/silkcircuit are the same repository — both resolve to the same
    -- HEAD and GitHub redirects the clone. Keeping the -nvim spelling because
    -- that string is the key in lazy-lock.json; renaming it would orphan the
    -- pin and re-clone under a new directory for no gain.
    "hyperb1iss/silkcircuit-nvim",
    lazy = false,
    priority = 900,

    -- NO config FUNCTION, DELIBERATELY.
    --
    -- This spec used to run, wrapped in pcall:
    --     require("silkcircuit").setup({})
    -- on the assumption that "silkcircuit" was the module name. Checked against
    -- the plugin source rather than the README: the module name was right, but
    -- the call was doing nothing at all. setup(opts) only merges opts into
    -- config.defaults, and {} merges nothing. The colourscheme is loaded by
    -- colors/silkcircuit.lua, which calls require("silkcircuit").load()
    -- whether or not setup() ever ran.
    --
    -- So the pcall was guarding a call that could neither fail nor matter —
    -- and, worse, would have swallowed a genuine module-name error silently.
    -- The failure that actually needed to be loud (the scheme not installed at
    -- all) belongs to theme.apply(), and it now says so out loud.
    --
    -- To change the look, add opts here and call setup() UNGUARDED, so a
    -- signature change is a visible error rather than a silent reversion:
    --     variant = "neon" | "vibrant" | "soft" | "glow" | "dawn"  (default "neon")
    -- An unrecognised variant falls back to "neon" inside the plugin.
    -- Diagnostics: :checkhealth silkcircuit, and :SilkCircuit <variant> to try
    -- one live before committing to it.
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
