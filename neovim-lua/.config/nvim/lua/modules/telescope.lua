-- {{{ Settings
require('telescope').setup {
  defaults = {
    -- prompt_position = "bottom",
    prompt_prefix = "$",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "flex",
    winblend = 10,
    -- width = 0.8,
    -- preview_cutoff = 0,
    -- results_height = 1,
    -- results_width = 1,
    set_env = {['COLORTERM'] = 'truecolor'} -- default = nil,
  }
}

-- require('telescope').extensions.dap.configurations()

-- }}}
