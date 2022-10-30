-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use) -- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- {{{ LSP Capabilities

	-- Tree sitter support
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- LSP Support
	use("neovim/nvim-lspconfig")
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
		requires = {
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = { "cmake", "clangd", "hls", "sumneko_lua", "rust_analyzer" },
				})
			end,
		},
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	-- Completion
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	})

	-- Snippets
	use({
		"dcampos/nvim-snippy",
		requires = { "dcampos/cmp-snippy", "honza/vim-snippets" },
	})

	-- Auto formatting
	use("mhartington/formatter.nvim")

	-- Debugging
	use("mfussenegger/nvim-dap")

	-- }}}

	-- {{{ Utils

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

	-- Lua
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})

	-- }}}

	-- {{{ Languages

	use("lervag/vimtex")

	-- }}}

	-- {{{ Menus and UI

	-- Dashboard
	use("glepnir/dashboard-nvim")

	-- Tree
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				"s1n7ax/nvim-window-picker",
				tag = "v1.*",
				config = function()
					require("window-picker").setup({
						autoselect_one = true,
						include_current = false,
						filter_rules = {
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify", "quickfix" },

								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal" },
							},
						},
						other_win_hl_color = "#e35e4f",
					})
				end,
			},
		},
	})

	-- Tab line
	use({
		"akinsho/bufferline.nvim",
		tag = "v2.*",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("bufferline").setup()
		end,
	})

	-- Status line
	use({
		"nvim-lualine/lualine.nvim",
		after = "github-nvim-theme",
		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight", -- or you can assign github_* themes individually.
					-- ... your lualine config
				},
			})
		end,
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})

	-- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Indent lines
	use("lukas-reineke/indent-blankline.nvim")

	-- Theme
	use("projekt0n/github-nvim-theme")
	use("folke/tokyonight.nvim")
	use("fenetikm/falcon")

	-- }}}
end)
