-- Placeholder. Drop your real config here.
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.expandtab = true

-- Machine-specific overrides, if any. pcall so a missing file is not fatal.
pcall(require, "local")
