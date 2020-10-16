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

  -- Completion and linting
  use {
    "neovim/nvim-lspconfig",
    {
      {
        "nvim-lua/completion-nvim",
        event = "InsertEnter *",
        requires = {
          {"aca/completion-tabnine", run = "./install.sh", event = "InsertEnter *"},
          {"steelsojka/completion-buffers", event = "InsertEnter *"},
          {"hrsh7th/vim-vsnip", event = "InsertEnter *"},
          {"hrsh7th/vim-vsnip-integ", event = "InsertEnter *"}
        }
      },
      "nvim-lua/lsp_extensions.nvim",
      "nvim-lua/diagnostic-nvim",
      {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = "nvim-treesitter/completion-treesitter"
      }
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

  -- Colorizer
  use {"norcalli/nvim-colorizer.lua", as = "nvim-colorizer"}

  -- Rainbow Brackets
  use "luochen1990/rainbow"

  -- Vim Wiki
  use {
    "vimwiki/vimwiki",
    event = {"BufNewFile ~/Documents/vimwiki/*.wiki", "BufRead ~/Documents/vimwiki/*.wiki"},
    cmd = {"VimwikiIndex", "VimwikiDiaryIndex"}
  }

  -- TODO: Todoist
  -- use {"romgrk/todoist.vim", run = ":TodoistInstall"}
  -- use {"liuchengxu/vim-clap", run = ":Clap install-binary!"}

  -- }}}

  -- {{{ Language Support

  use "sheerun/vim-polyglot"

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
    {
      "vim-pandoc/vim-pandoc",
      requires = {"vim-pandoc/vim-pandoc-syntax", "vim-pandoc/vim-rmarkdown"},
      ft = {"pandoc", "markdown", "rmarkdown"}
    },
    {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", ft = {"pandoc", "markdown"}}
  }

  -- Nix
  use {"LnL7/vim-nix", ft = "nix"}

  -- R
  use {"jalvesaq/Nvim-R", branch = "stable", ft = {"r", "rmarkdown"}}

  -- Rust
  use {"rust-lang/rust.vim", ft = "rust"}

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

  -- Tree
  use {"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons"}

  -- Startify
  use "mhinz/vim-startify"

  -- Airline
  use {"vim-airline/vim-airline", requires = "vim-airline/vim-airline-themes"}
  use "edkolev/tmuxline.vim"

  -- Icons in Airline and Startify
  use "ryanoasis/vim-devicons"
  -- }}}
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
