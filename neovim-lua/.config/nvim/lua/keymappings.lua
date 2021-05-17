-- Helper function
local set_keymap_noremap = function(mode, keys, command)
  vim.api.nvim_set_keymap(mode, keys, command, {noremap = true, silent = true})
end

-- Map leader
set_keymap_noremap('n', 'ñ', '<NOP>')
vim.g.mapleader = 'ñ'
vim.g.maplocalleader = 'º'

-- No hlsearch
set_keymap_noremap('n', "<Leader>h", ":set hlsearch!<CR>")

-- Better window movement
set_keymap_noremap('n', '<C-h>', '<C-w>h')
set_keymap_noremap('n', '<C-j>', '<C-w>j')
set_keymap_noremap('n', '<C-k>', '<C-w>k')
set_keymap_noremap('n', '<C-l>', '<C-w>l')

-- Better indenting
set_keymap_noremap('v', '<', '<gv')
set_keymap_noremap('v', '>', '>gv')

-- No escape
set_keymap_noremap('i', 'jk', '<ESC>')
set_keymap_noremap('i', 'kj', '<ESC>')
set_keymap_noremap('i', 'jj', '<ESC>')

-- Tab switch buffer
-- set_keymap_noremap('n', '<TAB>', ':bnext<CR>')
-- set_keymap_noremap('n', '<S-TAB>', ':bprevious<CR>')
set_keymap_noremap('n', '<TAB>', ':BufferNext<CR>')
set_keymap_noremap('n', '<S-TAB>', ':BufferPrevious<CR>')

-- Re-order to previous/next
set_keymap_noremap('n', '<A->>', ':BufferMoveNext<CR>')
set_keymap_noremap('n', '<A-<>', ':BufferMovePrevious<CR>')

set_keymap_noremap('n', '<A-1>', ':BufferGoto 1<CR>')
set_keymap_noremap('n', '<A-2>', ':BufferGoto 2<CR>')
set_keymap_noremap('n', '<A-3>', ':BufferGoto 3<CR>')
set_keymap_noremap('n', '<A-4>', ':BufferGoto 4<CR>')
set_keymap_noremap('n', '<A-5>', ':BufferGoto 5<CR>')
set_keymap_noremap('n', '<A-6>', ':BufferGoto 6<CR>')
set_keymap_noremap('n', '<A-7>', ':BufferGoto 7<CR>')
set_keymap_noremap('n', '<A-8>', ':BufferGoto 8<CR>')
set_keymap_noremap('n', '<A-9>', ':BufferLast<CR>')
set_keymap_noremap('n', '<C-w>', ':BufferClose<CR>')

set_keymap_noremap('n', '<C-o>', ':BufferOrderByDirectory<CR>')

-- Move selected line / block of text in visual mode
-- shift + k to move up
-- shift + j to move down
set_keymap_noremap('x', 'K', ":move '<-2<CR>gv-gv'")
set_keymap_noremap('x', 'J', ":move '>+1<CR>gv-gv'")
