local wk = require("which-key")

-- {{{ Using plugin which-key.nvim
wk.setup({
	plugins = {
		-- shows a list of your marks on ' and `
		marks = true,
		-- shows your registers on " in NORMAL or <C-r> in INSERT mode
		registers = true,
		spelling = {
			-- enabling this will show WhichKey when pressing z= to select spelling suggestions
			enabled = true,
			suggestions = 20,
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			-- adds help for operators like d, y, ... and registers them for motion / text object completion
			operators = true,
			-- adds help for motions
			motions = true,
			-- help for text objects triggered after entering an operator
			text_objects = true,
			-- default bindings on <c-w>
			windows = true,
			-- misc bindings to work with windows
			nav = true,
			-- bindings for folds, spelling and others prefixed with z
			z = true,
			-- bindings for prefixed with g
			g = true,
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
	},
	layout = {
		height = { min = 4, max = math.floor(vim.o.lines * 0.3) }, -- min and max height of the columns
		width = { min = 20, max = math.floor(vim.o.columns) }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	-- enable this to hide mappings for which you didn't specify a label
	ignore_missing = false,
	-- hide mapping boilerplate
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	-- show help message on the command line when the popup is visible
	show_help = true,
	-- automatically setup triggers
	triggers = "auto",
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
})

-- }}}

-- {{{ Helper function

local set_keymap_noremap = function(mode, keys, command)
	vim.api.nvim_set_keymap(mode, keys, command, { noremap = true, silent = true })
end

-- }}}

-- {{{ Map leader

vim.keymap.set("n", "ñ", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = "ñ"
vim.g.maplocalleader = "º"

-- }}}

-- {{{ Tree

vim.keymap.set("n", "<C-n>", "<cmd>NeoTreeFocusToggle<cr>", { silent = true })

-- }}}

-- {{{ Trouble

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

-- }}}

-- {{{ Windows

wk.register({
	[""] = {
		name = "window", -- optional group name
		["<C-h>"] = { "<C-w>h", "Go to left window" },
		["<C-j>"] = { "<C-w>j", "Go to down window" },
		["<C-k>"] = { "<C-w>k", "Go to up window" },
		["<C-l>"] = { "<C-w>l", "Go to right window" },
	},
}, { prefix = "" })

-- }}}

-- {{{ Utility

-- No hlsearch
wk.register({ h = { ":set hlsearch!<CR>", "No hlsearch" } }, { prefix = "<leader>" })
-- set_keymap_noremap('n', "<Leader>h", ":set hlsearch!<CR>")

-- Better indenting
wk.register({
	["<"] = { "<gv", "Unindent" }, -- Unindent line
	[">"] = { ">gv", "Indent" }, -- Indent line
}, { prefix = "", mode = "v" })

wk.register({
	["K"] = { ":move '<-2<CR>gv-gv'", "Move line down" },
	["J"] = { ":move '>+1<CR>gv-gv'", "Move line up" },
}, { prefix = "", mode = "x" })

-- No escape
wk.register({
	["jk"] = { "<ESC>", "Exit insert mode" },
	["kj"] = { "<ESC>", "Exit insert mode" },
	["jj"] = { "<ESC>", "Exit insert mode" },
}, { prefix = "", mode = "i" })

-- }}}
--
-- -- {{{ Buffers

-- Tab switch buffer
wk.register({
	["<TAB>"] = { ":BufferLineCycleNext<CR>", "Switch to next buffer" },
	["<S-TAB>"] = { ":BufferLineCyclePrev<CR>", "Switch to previous buffer" },
}, { prefix = "" })

-- Re-order to previous/next
wk.register({
	b = {
		name = "buffers",
		f = { "<cmd>lua require'telescope-builtin'.buffers()<cr>", "Find buffer" },
		[">"] = { ":BufferLineMoveNext<CR>", "Move buffer to next position" },
		["<"] = { ":BufferLineMovePrev<CR>", "Move buffer to previous position" },
		["1"] = { ":BufferLineGoToBuffer 1<CR>", "Go to buffer 1" },
		["2"] = { ":BufferLineGoToBuffer 2<CR>", "Go to buffer 2" },
		["3"] = { ":BufferLineGoToBuffer 3<CR>", "Go to buffer 3" },
		["4"] = { ":BufferLineGoToBuffer 4<CR>", "Go to buffer 4" },
		["5"] = { ":BufferLineGoToBuffer 5<CR>", "Go to buffer 5" },
		["6"] = { ":BufferLineGoToBuffer 6<CR>", "Go to buffer 6" },
		["7"] = { ":BufferLineGoToBuffer 7<CR>", "Go to buffer 7" },
		["8"] = { ":BufferLineGoToBuffer 8<CR>", "Go to buffer 8" },
		["9"] = { ":BufferLineGoToBuffer 9<CR>", "Go to buffer 9" },
	},
}, { prefix = "<leader>" })

wk.register({
	["<C-c>"] = { ":BufferLinePickClose<CR>", "Close buffer" },
	["<C-o>"] = { ":BufferLineOrderByDirectory<CR>", "Order buffer by directory" },
}, { prefix = "" })

-- }}}

-- TODO: {{{ Which key
local map = vim.api.nvim_set_keymap

-- {{{ Telescope

wk.register({
	f = {
		name = "file",
		f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find File" },
		r = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Find File" },
	},
}, { prefix = "<leader>" })

-- LSP References
map("n", "<leader>tr", [[<cmd>lua require('telescope.builtin').lsp_references()<CR>]], {})

-- LSP Definitions
map("n", "<leader>td", [[<cmd>lua require('telescope.builtin').lsp_definitions()<CR>]], {})

-- Live grep
map("n", "<leader>lg", [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], {})

-- Help tags
map("n", "<leader>fh", [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], {})

-- Search man entries
map("n", "<leader>mp", [[<cmd>lua require('telescope.builtin').man_pages()<CR>]], {})

-- }}}

-- {{{ Git

-- Git files
map("n", "<leader>gf", [[<cmd>lua require('telescope.builtin').git_files()<CR>]], {})

-- Git commits
map("n", "<leader>gc", [[<cmd>lua require('telescope.builtin').git_commits()<CR>]], {})

-- Git branches
map("n", "<leader>gb", [[<cmd>lua require('telescope.builtin').git_branches()<CR>]], {})

-- Git status
map("n", "<lesader>gs", [[<cmd>lua require('telescope.builtin').git_status()<CR>]], {})

-- }}}
