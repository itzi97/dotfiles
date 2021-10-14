vim.opt.filetype = 'on'

-- General settings
vim.opt.hidden = true
vim.opt.showmatch = true
vim.opt.showmode = false
vim.opt.conceallevel = 2
vim.opt.scrolloff = 5
vim.opt.ruler = true
vim.opt.modeline = true

-- Font
vim.opt.guifont = "FiraCode Nerd Font 10"

-- Wrap
vim.opt.textwidth = 80
vim.opt.wrap = true
vim.opt.whichwrap = vim.o.whichwrap .. "<,>,[,],h,l"
vim.opt.showbreak = "﬌"

-- Always show sign column
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = tostring(vim.o.textwidth + 1)

-- Set completion sources
vim.opt.completeopt = "menuone,noselect"

-- Folding
vim.opt.foldmethod = "marker"

-- Splitting

-- Set tabsize
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Indent
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Set list characters
-- vim.wo.list = true
vim.opt.list = true
vim.opt.listchars:append("tab:» ,")
vim.opt.listchars:append("trail:·,")
vim.opt.listchars:append("nbsp:⍽,")
vim.opt.listchars:append("space:⋅")
vim.opt.listchars:append("eol:↴")

-- Set line number
vim.opt.number = true
vim.opt.relativenumber = true
