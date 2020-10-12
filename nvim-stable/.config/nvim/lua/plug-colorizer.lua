vim.cmd [[ packadd nvim-colorizer ]]
require("colorizer").setup({"*", markdown = {mode = "background"}}, {mode = "foreground"})
