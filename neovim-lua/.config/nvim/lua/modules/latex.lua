vim.g.tex_flavor = "latex"

vim.g.vimtex_syntax_conceal = {
	accents = 1,
	greek = 1,
	math_bounds = 1,
	math_delimiters = 1,
	math_super_sub = 1,
	math_symbols = 1,
	styles = 1,
}

vim.g.vimtex_view_method = "zathura"

vim.g.vimtex_compiler_latexmk_engines = { _ = "-lualatex" }

vim.g.vimtex_compiler_latexmk = {
	backend = "jobs",
	background = 1,
	build_dir = "",
	callback = 1,
	continuous = 1,
	executable = "latexmk",
	hooks = {},
	options = {
		"-verbose",
		"-file-line-error",
		"-synctex=1",
		"-interaction=nonstopmode",
		"--shell-escape",
	},
}
