-- Settings
require'neuron'.setup {
	virtual_titles = true,
	mappings = true,
	run = nil, -- function to run when in neuron dir
	neuron_dir = "~/Documents/neuron",
	leader = "gz", -- the leader key to for all mappings, remember with 'go zettel'
}

-- Mappings
--local bmap = vim.api.nvim_buf_set_keymap

-- Click enter on [[my_link]] or [[[my_link]]] to enter it
--bmap("n", "<CR>", "<cmd>lua require'neuron'.enter_link()<CR>", {})

-- Create new note
--bmap(
--	"n",
--	"gzn",
--	"<cmd>lua require'neuron/cmd'.new_edit(require'neuron'.config.neuron_dir)<CR>",
--	{}
--)
