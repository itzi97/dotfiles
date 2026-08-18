-- Treesitter: real syntax trees rather than regex highlighting. Also what
-- mini.ai uses for "inside function" / "around class" text objects.

return {
  "nvim-treesitter/nvim-treesitter",
  -- PINNED TO master ON PURPOSE.
  --
  -- nvim-treesitter's default branch is now `main`, which is a rewrite with an
  -- entirely different API: no ensure_installed, no nvim-treesitter.configs.
  -- Configured the old way against the new branch, it silently installs
  -- nothing — :checkhealth showed only Fedora's bundled parsers and no error
  -- pointing at the cause (2026-08-12).
  --
  -- master is stable, is what kickstart pins, and does what's written below.
  -- Revisit when `main` is the documented default everywhere — and when you do,
  -- expect to rewrite this file rather than tweak it.
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  main = "nvim-treesitter.configs",
  opts = {
    -- Only the languages actually used on this machine. Every parser is a
    -- compile on install and a download on update; a long list here is how
    -- `:TSUpdate` turns into a coffee break.
    --   python, c, cpp   coursework and the engine work in uni.txt
    --   lua              this config
    --   latex, bibtex    CV and reports
    --   markdown         the Space documents
    --   bash, fish       dotfiles
    ensure_installed = {
      "python", "c", "cpp", "lua", "latex", "bibtex",
      "markdown", "markdown_inline", "bash", "fish",
      "json", "yaml", "toml", "query", "vim", "vimdoc",
    },
    auto_install = true,
    highlight = {
      enable = true,
      -- vimtex does its own syntax work for LaTeX and the two disagree; the
      -- vimtex docs are explicit about not letting treesitter own tex
      -- highlighting alone. Keep vim's regex syntax running alongside it.
      additional_vim_regex_highlighting = { "latex", "markdown" },
    },
    indent = { enable = true },
  },
}
