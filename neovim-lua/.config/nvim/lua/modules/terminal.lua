-- Position + size
vim.g.floaterm_width = 0.85
vim.g.floaterm_height = 0.85
vim.g.floaterm_position = "center"

-- Transparency
vim.api.nvim_exec([[
  highlight Floaterm guibg=NONE
  highlight FloatermBorder guibg=NONE guifg=#d79921
]], false)

vim.g.floaterm_winblend = 10

-- Keybinds
vim.g.floaterm_keymap_new = '<F7>'
vim.g.floaterm_keymap_prev = '<F8>'
vim.g.floaterm_keymap_next = '<F9>'
vim.g.floaterm_keymap_toggle = '<F12>'
vim.g.floaterm_keymap_kill = '<F11>'
