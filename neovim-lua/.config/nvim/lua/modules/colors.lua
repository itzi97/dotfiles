vim.o.termguicolors = true

-- {{{ Sonokai

-- Sonokai options
vim.g.sonokai_style = 'andromeda'
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_disable_italic_comment = 0
vim.g.sonokai_transparent_background = 0
vim.g.sonokai_sign_column_background = 'none'
vim.g.sonokai_current_word = 'bold'
-- vim.cmd [[ colorscheme  sonokai ]]
-- }}}

-- {{{ Material

vim.g.material_style = "deep ocean"

require('material').setup({

  contrast = true, -- Enable contrast for sidebars, floating windows and popup menus like Nvim-Tree
  borders = false, -- Enable borders between verticaly split windows

  popup_menu = "dark", -- Popup menu style ( can be: 'dark', 'light', 'colorful' or 'stealth' )

  italics = {
    comments = false, -- Enable italic comments
    keywords = false, -- Enable italic keywords
    functions = false, -- Enable italic functions
    strings = false, -- Enable italic strings
    variables = false -- Enable italic variables
  },

  contrast_windows = { -- Specify which windows get the contrasted (darker) background
    "NvimTree", -- File managertree.nvim
    "dashboard", -- Init dashboard
    "packer", -- Darker packer background
    -- "terminal", -- Darker flaoterm background
    "qf" -- Darker qf list background
  },

  text_contrast = {
    lighter = false, -- Enable higher contrast text for lighter style
    darker = true -- Enable higher contrast text for darker style
  },

  disable = {
    background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
    term_colors = true, -- Prevent the theme from setting terminal colors
    eob_lines = false -- Hide the end-of-buffer lines
  },

  custom_highlights = {} -- Overwrite highlights with your own
})
vim.cmd [[ colorscheme  material ]]

-- }}}
