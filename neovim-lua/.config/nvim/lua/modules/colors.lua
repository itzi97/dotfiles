-- {{{ Colorscheme
vim.o.termguicolors = true

-- Sonokai options
vim.g.sonokai_style = 'andromeda'
vim.g.sonokai_enable_italic = 1
vim.g.sonokai_disable_italic_comment = 0
vim.g.sonokai_transparent_background = 1
vim.g.sonokai_sign_column_background = 'none'
vim.g.sonokai_current_word = 'bold'

-- vim.api.nvim_command('colorscheme  sonokai')
vim.cmd [[ colorscheme  sonokai ]]

-- }}}

-- {{{ Indent guide

-- indentLine
--vim.g.indentLine_showFirstIndentLevel = 1
--vim.g.indentLine_enabled = 1
--vim.g.indentLine_char = "¦"

--vim.g.indentLine_fileTypeExclude = {"text", "help", "startify"}

-- Indent guides nvim
--require('indent_guides').setup({
  -- put your options in here
  --indent_levels = 30,
  --indent_guide_size = 1,
  --indent_start_level = 1,
  --indent_space_guides = true,
  --indent_tab_guides = false,
  --indent_soft_pattern = '\\s',
  --exclude_filetypes = {
    --'help', 'dashboard', 'dashpreview', 'NvimTree', 'vista', 'sagahover',
    --'startify'
  --}

  -- even_colors = { fg ='#2E323A',bg='#34383F' };
  -- odd_colors = {fg='#34383F',bg='#2E323A'};
--})

-- }}}
