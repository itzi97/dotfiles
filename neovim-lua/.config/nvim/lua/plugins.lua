vim.cmd [[ packadd packer.nvim ]]
vim.cmd [[ autocmd BufWritePost plugins.lua PackerCompile ]]

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

return require'packer'.startup(function()
  local use = require'packer'.use

  -- Packer can manage itself as an optional plugin
  use {"wbthomason/packer.nvim", opt = true}

  -- {{{ IDE Like features

  -- Completion
  -- use "hrsh7th/nvim-compe"

  -- Snippets
  use {"SirVer/ultisnips", requires = {"honza/vim-snippets"}}

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    requires = {
      "onsails/lspkind-nvim", "glepnir/lspsaga.nvim",
      "nvim-lua/lsp_extensions.nvim", "nvim-lua/lsp-status.nvim",
      "folke/lsp-colors.nvim", {
        "weilbith/nvim-code-action-menu",
        use = 'CodeActionMenu',
        requires = "kosayoda/nvim-lightbulb"
      } -- {'RishabhRD/nvim-lsputils', requires = 'RishabhRD/popfix'}
    }
  }

  -- Completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'ray-x/cmp-treesitter',
      'quangnguyen30192/cmp-nvim-ultisnips', -- 'kdheepak/cmp-latex-symbols',
      'hrsh7th/cmp-path', 'kristijanhusak/vim-dadbod-completion'
    }
  }

  -- Further diagnostics
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("trouble").setup {} end
  }

  -- }}}

  -- {{{ Languages

  -- Polyglot
  use "sheerun/vim-polyglot"

  -- C++
  use "jackguo380/vim-lsp-cxx-highlight"

  -- Golang
  use {"fatih/vim-go", run = "GoUpdateBinaries"}

  -- Julia
  use "JuliaEditorSupport/julia-vim"

  -- LaTeX
  use {"lervag/vimtex", commit = "fbe94cd3eaed89d6c1236af486466b1fcc3b82c9"}

  -- Lua
  use "euclidianAce/BetterLua.vim"

  -- Mathematica
  use "rsmenon/vim-mathematica"

  -- Markdown
  use {"npxbr/glow.nvim", run = "GlowInstall"}
  use {'vim-pandoc/vim-pandoc', requires = 'vim-pandoc/vim-pandoc-syntax'}

  -- R
  use {'jalvesaq/Nvim-R', branch = 'stable'}

  -- Rust
  use "rust-lang/rust.vim"

  -- }}}

  -- {{{ Misc

  -- Star wars
  use {"mattn/vim-starwars"}

  -- Spelling
  use {
    'lewis6991/spellsitter.nvim',
    requires = {'nvim-treesitter/nvim-treesitter'},
    config = function() require'spellsitter'.setup() end
  }

  -- Discord rich presence
  use {"aurieh/discord.nvim", run = ":UpdateRemotePlugins"}

  -- Formatter
  use "mhartington/formatter.nvim"

  -- Delimiters, braces, etc.
  use {
    "blackCauldron7/surround.nvim",
    config = function() require"surround".setup {mappings_style = "sandwich"} end
  }
  use "tpope/vim-endwise"
  use "rstacruz/vim-closer"

  -- Comment bindings
  use "preservim/nerdcommenter"

  -- Floating terminal
  use "akinsho/toggleterm.nvim"

  -- Switch
  use {
    "AndrewRadev/switch.vim",
    config = function()
      vim.api.nvim_set_keymap('n', '-', ':Switch<CR>',
                              {noremap = true, silent = true})
    end
  }

  -- Which key
  use "folke/which-key.nvim"

  -- ORG Mode Vim
  use {"nvim-neorg/neorg", ft = "norg", requires = "nvim-lua/plenary.nvim"}

  -- Databases
  use {"kristijanhusak/vim-dadbod-ui", requires = "tpope/vim-dadbod"}

  -- Speed up Neovim
  use "lewis6991/impatient.nvim"

  -- Debugger
  use {
    'mfussenegger/nvim-dap',
    requires = {
      "mfussenegger/nvim-dap-python", 'jbyuki/one-small-step-for-vimkind',
      'theHamsta/nvim-dap-virtual-text', "rcarriga/nvim-dap-ui"
    }
  }

  -- Clip register
  use {
    "AckslD/nvim-neoclip.lua",
    config = function()
      require('neoclip').setup({default_register = {'"', '+', '*'}})
    end
  }

  -- }}}

  -- {{{ Aesthetic

  -- Color scheme
  -- use "sainnhe/sonokai"
  use 'marko-cerovac/material.nvim'

  -- Better highlighting and colors
  use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

  -- Indent guides
  use {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require'indent_blankline'.setup {
        show_end_of_line = true,
        space_char_blankline = " ",
        show_current_context = true,
        use_treesitter = true,
        buftype_exclude = {"terminal"},
        filetype_exclude = {"dashboard", "help"}
      }
    end
  }

  -- Todo comments
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require'todo-comments'.setup {} end
  }

  -- Zen Mode
  use {
    "folke/zen-mode.nvim",
    config = function() require'zen-mode'.setup {} end
  }

  -- Git
  use {
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function() require'gitsigns'.setup() end
  }

  -- Scroll
  use {
    'karb94/neoscroll.nvim',
    config = function() require'neoscroll'.setup() end
  }

  -- Highlighting
  use 'yamatsum/nvim-cursorline'

  -- Colorizer
  use {
    "norcalli/nvim-colorizer.lua",
    config = function() require'colorizer'.setup() end
  }

  -- }}}

  -- {{{ Menus

  -- Dashboard
  use "glepnir/dashboard-nvim"

  -- Luatree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  }

  -- Barbar
  use {
    "romgrk/barbar.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  }

  -- Lualine
  use {
    "hoob3rt/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true}
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-dap.nvim"
    }
  }

  -- Better quickfix
  use 'kevinhwang91/nvim-bqf'

  -- }}}
end)
