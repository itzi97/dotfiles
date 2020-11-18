-- Load from packpath
vim.cmd [[ packadd nvim-dap ]]

local dap = require("dap")
dap.adapters.python = {type = "executable", command = "python", args = {"-m", "debugpy.adapter"}}

-- show virtual text for current frame
vim.g.dap_virtual_text = true
