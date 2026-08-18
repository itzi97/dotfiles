-- Keymaps that don't belong to a plugin. Plugin-specific maps live next to the
-- plugin that owns them, so removing a plugin removes its keys with it.

local map = vim.keymap.set

-- Clear search highlight. <Esc> because that is what the hand does anyway.
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- --- diagnostics -----------------------------------------------------------
-- Virtual text is off (see options.lua), so this is how you read the message.
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- --- window navigation -----------------------------------------------------
-- Without these, moving between splits is <C-w>h, which is two keys too many
-- for something done constantly.
map("n", "<C-h>", "<C-w><C-h>", { desc = "Window left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Window right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Window down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Window up" })

-- --- editing ---------------------------------------------------------------
-- Move the selected block up/down, re-indenting as it goes.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Stay in visual mode when indenting, so >>> is one key held rather than
-- three separate selections.
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste over a selection without clobbering the register with what you just
-- replaced. The single most-missed default in vim.
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- --- files -----------------------------------------------------------------
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })

-- Terminal escape. Without this there is no way out of :terminal except the
-- mouse, which defeats the point.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
