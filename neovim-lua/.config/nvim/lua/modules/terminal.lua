-- Position + size
require'FTerm'.setup({
  -- Command to run inside the terminal. It could be a `string` or `table`
  cmd = os.getenv('SHELL'),

  -- Neovim's native window border. See `:h nvim_open_win` for more configuration options.
  border = 'double',

  -- Close the terminal as soon as shell/command exits.
  -- Disabling this will mimic the native terminal behaviour.
  auto_close = false,

  -- Highlight group for the terminal. See `:h winhl`
  hl = 'Normal',

  -- Transparency of the floating window. See `:h winblend`
  blend = 10,

  -- Object containing the terminal window dimensions.
  -- The value for each field should be between `0` and `1`
  dimensions = {
    height = 0.8, -- Height of the terminal window
    width = 0.8, -- Width of the terminal window
    x = 0.5, -- X axis of the terminal window
    y = 0.5 -- Y axis of the terminal window
  }
})

-- Example keybindings
local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

map('n', '<F12>', '<CMD>lua require("FTerm").toggle()<CR>', opts)
map('t', '<F12>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', opts)
