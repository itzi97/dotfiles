-- Show relative numbers
-- local vim = require("vim")
local function global_settings()
  -- Define mappings
  vim.g.mapleader = "ñ"
  vim.g.maplocalleader = "º"

  vim.o.number = true
  vim.o.relativenumber = true

  -- Set to wrap at textwidth (80)
  vim.o.wrap = true
  vim.o.textwidth = 80
  vim.o.showbreak = "﬌"

  -- Highlight matching brace
  vim.o.showmatch = true

  -- Enable folding by markers
  vim.o.foldmethod = "marker"

  -- Prettify code
  vim.o.conceallevel = 2

  -- Set tabstop to 8 (to show when tabs are present), use spaces for tabs instead
  vim.o.tabstop = 8
  vim.o.softtabstop = 2
  vim.o.expandtab = true
  vim.o.shiftwidth = vim.o.softtabstop

  -- Enable auto and smart indents
  vim.o.smartindent = true
  vim.o.autoindent = true
  vim.o.smarttab = true
  vim.o.list = true

  -- Prettify code with conceal
  vim.o.listchars = "tab:»\\ ,trail:·,eol:↵,nbsp:⍽"
  vim.o.fillchars = "eob:·"

  -- Formatting options
  -- t: Respect textwidth
  -- c: Comments respect text width
  -- n: Respect list indents
  -- j: Remote comment leader when joining lines
  vim.o.formatoptions = "tcnj"

  -- Spelling
  vim.o.spell = false
  vim.o.spelllang = "en_us,es"

  -- Text edit might fail if this is not set
  vim.o.hidden = true

  -- Always show sign column
  -- vim.o.signcolumn = "yes"
  vim.api.nvim_set_option("signcolumn", "yes")

  -- Give more space for displaying messages
  vim.o.cmdheight = 2

  -- Having a longer update time leades to noticeable delays and poor user experience
  vim.o.updatetime = 300

  -- Don't pass messages to |ins-complete-menu|
  if not vim.o.shortmess then
    vim.o.shortmess = vim.o.shortmess + "c"
  else
    vim.o.shortmess = "c"
  end

  -- Turn on wildmenu and ignore compiled files
  vim.o.wildmenu = true
  vim.o.wildignore = "*.o,*~,*.pyc"

  -- Always display current position
  vim.o.ruler = true
end

return {global = global_settings}
