-- Map leader
vim.api.nvim_set_keymap('n', 'ñ', '', {})
vim.g.mapleader = 'ñ'
vim.g.maplocalleader = 'º'

-- General settings
vim.o.hidden = true
vim.o.showmatch = true
vim.o.conceallevel = 2
vim.o.scrolloff = 5

-- Font
vim.o.guifont = "Hack Nerd Font 10"

-- Wrap
vim.o.textwidth = 80
vim.o.wrap = true
vim.o.showbreak = "﬌"

-- Always show sign column
vim.wo.signcolumn = "yes"
vim.wo.colorcolumn = tostring(vim.o.textwidth + 1)
vim.o.signcolumn = vim.wo.signcolumn
vim.o.colorcolumn = vim.wo.colorcolumn

-- Set completion sources
vim.o.completeopt = "menuone,noselect"

-- Folding
vim.wo.foldmethod = "marker"

-- Set tabsize
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.o.tabstop = vim.bo.tabstop
vim.o.shiftwidth = vim.bo.shiftwidth
vim.o.expandtab = vim.bo.expandtab

-- Set list characters
vim.wo.list = true
vim.wo.listchars = 'tab:» ,trail:·,eol:↵,nbsp:⍽'
vim.o.list = vim.wo.list
vim.o.listchars = vim.wo.listchars

-- Set line number
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.number = vim.wo.number
vim.o.relativenumber = vim.wo.relativenumber
