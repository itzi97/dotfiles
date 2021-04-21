local map = vim.api.nvim_set_keymap

-- {{{ nvim-compe

require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    -- Common sources
    buffer = true,
    calc = true,
    path = true,
    tags = true,
    spell = true,
    omni = true,

    -- Neovim specific
    nvim_lsp = true,
    nvim_lua = true,

    -- External plugins
    vsnip = false,
    snippets_nvim = false,
    ultisnips = true,
    treesitter = true
  }
}

-- }}}

-- {{{ Tab completion

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
    -- elseif vim.fn.call("vsnip#available", {1}) == 1 then
    -- return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
    -- elseif vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    -- return t "<Plug>(vsnip-jump-prev)"
  else
    return t "<S-Tab>"
  end
end

map("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
map("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
map("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- }}}

-- {{{ Ultisnips

-- map("i", "<C-k>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-k>'",
-- {expr = true})

-- Completion shortcuts for Ultisnips
vim.g.UltiSnipsExpandTrigger = '<c-k>'
vim.g.UltiSnipsJumpForwardTrigger = '<C-w>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-b>'

-- }}}

-- {{{ Snippets

-- local snippets = require 'snippets'
-- local snip_utils = require 'snippets.utils'

-- -- Set up mappings
-- local inoremap = function(keys, command)
-- vim.api.nvim_set_keymap('i', keys, command, {noremap = true, expr = true})
-- end

-- inoremap('<C-k>', "<cmd>lua return require'snippets'.expand_or_advance(1)<CR>")
-- inoremap('<C-j>', "<cmd>lua return require'snippets'.advance_snippet(-1)<CR>")

-- snippets.snippets = {
-- _global = {
-- todo = "TODO(Itziar)",
-- author = "Itziar Morales Rodríguez",
-- copyright = snip_utils.force_comment(
--[[Copyright (C) Itziar Morales Rodríguez ${=os.date("%Y")}
        --]]
-- ),

-- -- System information
-- uname = function() return vim.loop.os_uname().sysname end,

-- -- Date
-- date = function() return os.date() end,

-- -- TODO: Time
-- epoch = function() return os.time() end,

-- -- User note
-- note = [[NOTE(${1=io.popen("id -un"):read"*l"}): ]],

-- -- Random color
-- randcolor = function()
-- return string.format("#%06X", math.floor(math.random() * 0xFFFFFF))
-- end
-- },

-- lua = {
-- req = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = require '$1']],
-- func = [[function${1|vim.trim(S.v):gsub("^%S"," %0")}(${2|vim.trim(S.v)})$0 end]],
-- ["local"] = [[local ${2:${1|S.v:match"([^.()]+)[()]*$"}} = ${1}]],
-- -- Match the indentation of the current line for newlines.
-- ["for"] = snip_utils.match_indentation [[
-- for ${1:i}, ${2:v} in ipairs(${3:t}) do
-- $0
-- end]]
-- },

-- tex = {begin = [[\\begin\{${1}\} \\end\{${1}\}]]}
-- }

-- }}}
