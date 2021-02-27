-- Set global options
vim.g.nvim_tree_side = "left"
vim.g.nvim_tree_width = 30
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }
vim.g.nvim_tree_auto_ignore_ft = {'startify', 'dashboard'}
vim.g.nvim_tree_quit_on_open = 0
vim.g.nvim_tree_follow = 0
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_hide_dotfiles = 0
vim.g.nvim_tree_git_hl = 0
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_show_icons = {
	git = 1,
	folders =  1,
	files = 1,
}

-- Set keybinds
local keymap = vim.api.nvim_set_keymap
keymap("n", "<C-n>", ":NvimTreeToggle<CR>", {})
keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", {})
keymap("n", "<leader>n", ":NvimTreeFindFile<CR>", {})
