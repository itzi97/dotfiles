vim.cmd("packadd packer.nvim")

-- {{{ Ensure packer.nvim

local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
              install_path)
  execute 'packadd packer.nvim'
end

-- }}}

return require('packer').startup(function()
  local use = require'packer'.use

  -- Packer can manage itself as an optional plugin
  use {'wbthomason/packer.nvim', opt = true}

  -- {{{ IDE Like features

  -- Completion
  use {'hrsh7th/nvim-compe'}

  -- Snippets
  use {"hrsh7th/vim-vsnip", requires = "hrsh7th/vim-vsnip-integ"}

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'onsails/lspkind-nvim', 'glepnir/lspsaga.nvim', 'kosayoda/nvim-lightbulb'
    }
  }

  -- }}}

  -- {{{ Languages

  -- Polyglot
  use {"sheerun/vim-polyglot"}

  -- Golang
  use {'fatih/vim-go', run = 'GoUpdateBinaries'}

  -- Julia
  use {"JuliaEditorSupport/julia-vim"}

  -- LaTeX
  use {"lervag/vimtex"}

  -- Markdown
  use {'npxbr/glow.nvim', run = "GlowInstall"}

  -- Rust
  use {'rust-lang/rust.vim'}

  -- }}}

  -- {{{ Misc

  -- Discord rich presence
  use {"aurieh/discord.nvim", run = ":UpdateRemotePlugins"}

  -- Formatter
  use {"mhartington/formatter.nvim"}

  -- Delimiters
  use {"tpope/vim-surround"}

  -- Comment bindings
  use {"preservim/nerdcommenter"}

  -- Floating terminal
  use {"voldikss/vim-floaterm"}

  -- }}}

  -- {{{ Menus

  -- Dashboard
  use {"glepnir/dashboard-nvim"}

  -- Luatree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  }

  -- Lualine
  use {
    'hoob3rt/lualine.nvim',
    requires = {'kyazdani42/nvim-web-devicons', opt = true}
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
  }

  -- }}}

  -- {{{ Aesthetic

  -- Colorscheme
  use {"sainnhe/sonokai"}
  use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

  -- Indent guidelines
  use {"glepnir/indent-guides.nvim"}

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require("gitsigns").setup() end
  }

  -- }}}
end)
