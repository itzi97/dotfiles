vim.cmd [[ packadd nvim-colorizer ]]
require("colorizer").setup({
  "*",
  "!help",
  "!LuaTree",
  "!packer",
  "!startify",
  markdown = {mode = "background"}
}, {mode = "foreground"})
