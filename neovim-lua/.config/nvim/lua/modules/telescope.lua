-- {{{ Keymaps
local map = vim.api.nvim_set_keymap

-- Find files
map("n", "<leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<CR>]], {})

-- Live grep
map('n', '<leader>lg', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], {})

-- Buffers
map('n', '<leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], {})

-- Help tags
map('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], {})

-- Search man entries
map('n', "<leader>mp", [[<cmd>lua require('telescope.builtin').man_pages()<CR>]], {})

-- {{{ Git
-- Git files
map("n", "<leader>gf", [[<cmd>lua require('telescope.builtin').git_files()<CR>]], {})

-- Git commits
map("n", "<leader>gc", [[<cmd>lua require('telescope.builtin').git_commits()<CR>]], {})

-- Git branches
map("n", "<leader>gb", [[<cmd>lua require('telescope.builtin').git_branches()<CR>]], {})

-- Git status
map("n", "<leader>gs", [[<cmd>lua require('telescope.builtin').git_status()<CR>]], {})

-- }}}

-- 

-- }}}

-- {{{ Settings
require('telescope').setup {
  defaults = {
    prompt_position = "bottom",
    prompt_prefix = "$",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "flex",
    winblend = 10,
    width = 0.8,
    preview_cutoff = 0,
    results_height = 1,
    results_width = 1,
    set_env = {['COLORTERM'] = 'truecolor'} -- default = nil,
  }
}

-- }}}

-- {{{ Dashboard

vim.g.dashboard_default_executive = "telescope"
vim.g.dashboard_custom_header = {
  '          ▀████▀▄▄              ▄█ ',
  '            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ',
  '    ▄        █          ▀▀▀▀▄  ▄▀  ',
  '   ▄▀ ▀▄      ▀▄              ▀▄▀  ',
  '  ▄▀    █     █▀   ▄█▀▄      ▄█    ',
  '  ▀▄     ▀▄  █     ▀██▀     ██▄█   ',
  '   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ',
  '    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ',
  '   █   █  █      ▄▄           ▄▀   '
}

-- }}}
