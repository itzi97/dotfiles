-- TODO: Must have
vim.o.filetype = 'on'
-- vim.o.plugin = 'on'
-- vim.o.indent = 'on'

-- General settings
vim.o.hidden = true
vim.o.showmatch = true
vim.o.showmode = false
vim.o.conceallevel = 2
vim.o.scrolloff = 5
vim.o.ruler = true
vim.o.modeline = true

-- Font
vim.o.guifont = "FiraCode Nerd Font 10"

-- Wrap
vim.o.textwidth = 80
vim.o.wrap = true
vim.o.whichwrap = vim.o.whichwrap .. "<,>,[,],h,l"
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

-- Splitting

-- Set tabsize
vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.o.tabstop = vim.bo.tabstop
vim.o.shiftwidth = vim.bo.shiftwidth
vim.o.expandtab = vim.bo.expandtab

-- Indent
vim.o.smarttab = true
vim.o.smartindent = true
vim.o.autoindent = true

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

-- Clipboard
vim.o.clipboard = "unnamedplus"
