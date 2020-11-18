vim.cmd [[packadd popup.nvim]]
vim.cmd [[packadd plenary.nvim]]
vim.cmd [[packadd telescope.nvim]]

-- totally optional to use setup
require("telescope").setup {
  defaults = {
    shorten_path = true -- currently the default value is true
  }
}

vim.api.nvim_set_keymap("n", "<leader>p", "<cmd>lua require'telescope.builtin'.git_files{}<CR>",
                        {noremap = true, silent = true})
