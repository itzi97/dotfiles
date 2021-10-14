require("toggleterm").setup {
  -- size can be a number or function which is passed the current terminal
  size = 20,
  open_mapping = [[<F12>]],
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  persist_size = true,
  direction = 'float',
  close_on_exit = false, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    width = math.floor(0.85 * vim.o.columns),
    height = math.floor(0.85 * vim.o.lines),
    winblend = 10,
    highlights = {border = "Normal", background = "Normal"}
  }
}

-- Custom terminals

local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new{
  cmd = 'lazygit',
  hidden = true,
  close_on_exit = true
}
local ranger = Terminal:new{cmd = 'ranger', hidden = true, close_on_exit = true}

function _lazygit_toggle() lazygit:toggle() end

function _ranger_toggle() ranger:toggle() end

local opts = {noremap = true, silent = true}
vim.api.nvim_set_keymap("n", "<F10>", "<cmd>lua _lazygit_toggle()<CR>", opts)
vim.api.nvim_set_keymap("n", "<F11>", "<cmd>lua _ranger_toggle()<CR>", opts)
