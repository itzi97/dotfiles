local packer = nil
local function init()
  if packer == nil then
    packer = require("packer")
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer can manage itself as an optional plugin
  use {"wbthomason/packer.nvim", opt = true}

  -- {{{ Fixing, Linting & Completion

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    {
      {
        "nvim-lua/completion-nvim",
        event = "InsertEnter *",
        requires = {
          {"aca/completion-tabnine", run = "./install.sh", event = "InsertEnter *"},
          {"steelsojka/completion-buffers", event = "InsertEnter *"},
          {
            "hrsh7th/vim-vsnip",
            event = "InsertEnter *",
            requires = {"hrsh7th/vim-vsnip-integ", event = "InsertEnter *"}
          }
        }
      },
      {"RishabhRD/nvim-lsputils", requires = "RishabhRD/popfix"},
      "nvim-lua/lsp_extensions.nvim",
      "nvim-lua/diagnostic-nvim",
      {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {"nvim-treesitter/completion-treesitter", "romgrk/nvim-treesitter-context"}
      }
    }
  }

  -- ALE
  use {
    "dense-analysis/ale",
    ft = {
      "sh",
      "zsh",
      "bash",
      "c",
      "cpp",
      "cmake",
      "cmake",
      "html",
      "markdown",
      "pandoc",
      "vim",
      "tex"
    }
  }

  -- TODO: Only use this when lsp doesn't offer formatting.
  use "sbdchd/neoformat"

  -- }}}

  -- {{{ Misc

  -- Discord Support
  use {"aurieh/discord.nvim", run = ":UpdateRemotePlugins"}

  -- Git Git Git!
  use {"mhinz/vim-signify", requires = "tpope/vim-fugitive"}

  -- Quotes, delimiters, etc.
  use "tpope/vim-surround"

  -- Comments
  use "preservim/nerdcommenter"

  -- Open file in last place it was edited
  use "farmergreg/vim-lastplace"

  -- Colorizer (use local version)
  use {"norcalli/nvim-colorizer.lua", as = "nvim-colorizer"}

  -- Rainbow Brackets
  use "luochen1990/rainbow"

  -- Vim Wiki
  use {
    "vimwiki/vimwiki",
    event = {"BufNewFile ~/Documents/vimwiki/*.wiki", "BufRead ~/Documents/vimwiki/*.wiki"},
    cmd = {"VimwikiIndex", "VimwikiDiaryIndex"}
  }

  -- }}}

  -- {{{ Language Support

  -- use "sheerun/vim-polyglot"

  -- C/C++
  use {"jackguo380/vim-lsp-cxx-highlight", ft = {"c", "cpp"}}

  -- Haskell
  use {"neovimhaskell/haskell-vim", ft = "haskell"}

  -- LaTeX
  use {"lervag/vimtex", ft = "tex"}

  -- Lua
  use {"euclidianAce/BetterLua.vim", "tjdevries/nlua.nvim", "rafcamlet/nvim-luapad", ft = "lua"}

  -- Go
  use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = "go"}

  -- Julia
  use {"JuliaEditorSupport/julia-vim", ft = "julia"}

  -- Markdown
  use {
    {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = {"pandoc", "markdown"}},
    {
      "vim-pandoc/vim-pandoc",
      requires = {"vim-pandoc/vim-pandoc-syntax", "vim-pandoc/vim-rmarkdown"},
      ft = {"pandoc", "markdown", "rmarkdown"}
    }
  }

  -- Nix
  use {"LnL7/vim-nix", ft = "nix"}

  -- PlantUML
  use {
    "weirongxu/plantuml-previewer.vim",
    as = "plantuml-previewer",
    requires = {"aklt/plantuml-syntax", "tyru/open-browser.vim"}
  }

  -- R
  use {"jalvesaq/Nvim-R", branch = "stable", event = "InsertEnter *", ft = {"r", "rmarkdown"}}

  -- Rust
  use {"rust-lang/rust.vim", ft = "rust"}

  -- Vue
  -- use {"posva/vim-vue", ft = "vue"}

  -- }}}

  -- {{{ Styling

  -- Color Themes
  use {"kaicataldo/material.vim", branch = "main"}
  use "morhetz/gruvbox"
  use "rakr/vim-one"
  use "NLKNguyen/papercolor-theme"
  use "tomasr/molokai"

  -- Indent Line
  use "Yggdroot/indentLine"

  -- }}}

  -- {{{ Visuals and Menus

  -- Float term
  use "voldikss/vim-floaterm"

  -- Telescope
  use {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-lua/telescope.nvim"}

  -- Tree
  use "kyazdani42/nvim-tree.lua"

  -- Startify
  use "mhinz/vim-startify"

  -- Galaxyline
  -- use "glepnir/galaxyline.nvim"

  -- Airline
  use {
    "vim-airline/vim-airline",
    requires = {"vim-airline/vim-airline-themes", "edkolev/tmuxline.vim"}
  }

  -- Icons in Airline, Startify, Lua Tree, Telescope
  use "ryanoasis/vim-devicons"
  use "kyazdani42/nvim-web-devicons"

  -- }}}
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
