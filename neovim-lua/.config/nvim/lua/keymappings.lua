local wk = require("which-key")

-- {{{ Using plugin which-key.nvim
wk.setup( {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
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
  motions = {
    count = true,
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "none", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "^:", "^ ", "^call ", "^lua " }, -- hide mapping boilerplate
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specifiy a list manually
  -- list of triggers, where WhichKey should not wait for timeoutlen and show immediately
  triggers_nowait = {
    -- marks
    "`",
    "'",
    "g`",
    "g'",
    -- registers
    '"',
    "<c-r>",
    -- spelling
    "z=",
  },
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for keymaps that start with a native binding
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by deafult for Telescope
  disable = {
    buftypes = {},
    filetypes = {},
  },
})

--}}}

-- {{{ Helper function

local set_keymap_noremap = function(mode, keys, command)
  vim.api.nvim_set_keymap(mode, keys,command, { noremap = true, silent = true})
end

-- }}}

-- {{{ Map leader

vim.keymap.set("n", "ñ", "<NOP>", { noremap = true, silent = true })
vim.g.mapleader = "ñ"
vim.g.maplocalleader = "º"

-- }}}

-- {{{ Tree

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", {silent = true})

-- }}}

-- {{{ TODO: Trouble

-- }}}

-- {{{ Windows

wk.register({
  [""] = {
    name = "window", -- optimal group name
    ["<C-h>"] = { "<C-w>h", "Go to left window" },
    ["<C-j>"] = { "<C-w>h", "Go to bottom window" },
    ["<C-k>"] = { "<C-w>h", "Go to top window" },
    ["<C-l>"] = { "<C-w>h", "Go to right window" },
  },
}, { prefix = ""})

-- }}}

-- {{{ Utility

-- No hlsearch
wk.register({ h = {":set hlsearch!<CR>", "No hlsearch" }}, { prefix = "<leader>"})
-- set_keymap_noremap("n", "<Leader>h", "set hlsearch!<CR>")

-- Better indenting
wk.register({
  ["<"] = { "<gv", "Unindent" }, -- Unindent line
  [">"] = { ">gv", "Indent" }, -- Indent line
}, { prefix = "", mode = "v"})

-- Move lines
wk.register({
  ["K"] = { ":move '<-2<CR>gv-gv'", "Move line down"},
  ["J"] = { ":move '>+1<CR>gv-gv'", "Move line down"},
}, { prefix = "", mode = "x" })

-- No escape
wk.register({
  ["jk"] = { "<ESC>", "Exit insert mode" },
  ["kj"] = { "<ESC>", "Exit insert mode" },
  ["jj"] = { "<ESC>", "Exit insert mode" },
}, { prefix = "", mode = "i"})
-- }}}

-- {{{ TODO: Buffeers

-- }}}
