-- LaTeX — the CV, and coursework reports.
--
-- This is the addition that makes the config yours rather than generic, and
-- there are two machine-specific details worth understanding before changing
-- anything here.
--
-- 1. COMPILER. vimtex shells out to `latexmk`, which is installed on the host,
--    from TeX Live (ADR-0018 makes TeX Live Tier 1 here).
--
--    THIS PARAGRAPH USED TO SAY THE OPPOSITE, and it is worth knowing why so
--    nobody reinstates it. It claimed latexmk was not on the host at all — that
--    it lived in the `uni` distrobox and reached us as an exported wrapper in
--    ~/.local/bin, working only because the box shares $HOME, and that
--    `tbx rm uni` would break LaTeX compilation with a confusing "latexmk not
--    found". None of that is true any more; ADR-0018 moved TeX Live onto the
--    host and the container is not in the path at all. Corrected 2026-08-26.
--
--    Consequence worth checking once, since it silently rode along with the old
--    arrangement: `-shell-escape` below exists for minted, and minted needs
--    `pygmentize` in the same place as the compiler. That used to be satisfied
--    by the container image. It now has to be on the host —
--    `command -v pygmentize` — or minted documents fail at compile time with an
--    error that blames shell-escape rather than the missing binary.
--
-- 2. VIEWER. zathura, installed on the host.
--
--    Started on okular since it ships with the KDE spin, but the `general`
--    viewer backend doesn't reliably auto-open after a compile — you had to
--    call :VimtexView by hand every time. zathura is vimtex's first-class
--    backend: it opens on first successful compile, and both forward search
--    (nvim -> page) and inverse search (ctrl-click in the PDF -> nvim) work
--    without configuration.
--
--    It's keyboard-driven, which is principle #9, and it's a small package.
--    okular stays installed because it came with the spin — it just stops
--    being the thing that opens PDFs.
--
--    (A note here used to explain that forward search worked "across the
--    container boundary" because only the compiler was containerised. There is
--    no boundary now — compiler and viewer are both on the host, so synctex
--    forward and inverse search are simply local. Removed 2026-08-26.)

return {
  "lervag/vimtex",
  lazy = false, -- vimtex explicitly asks not to be lazy-loaded; it manages its
                -- own filetype hooks and breaks subtly if deferred
  init = function()
    vim.g.vimtex_view_method = "zathura"

    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      -- Build into a subdirectory so aux/log/toc clutter doesn't sit next to
      -- the .tex — which matters more than usual here, because Documents/ is
      -- Nextcloud-synced and every intermediate file would sync to Hetzner.
      out_dir = "build",
      continuous = 1,
      options = {
        "-shell-escape",     -- needed by minted/pygments, common in CV templates
        "-verbose",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- Don't open the quickfix window on warnings. LaTeX warns about
    -- overfull hboxes constantly and it is almost never what you want to
    -- look at; errors still open it.
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- Ignore the noisiest warning classes outright.
    vim.g.vimtex_quickfix_ignore_filters = {
      "Underfull \\\\hbox",
      "Overfull \\\\hbox",
      "LaTeX Warning: .\\+ float specifier changed to",
    }
  end,
  keys = {
    { "<localleader>ll", "<cmd>VimtexCompile<CR>",     desc = "LaTeX: compile" },
    { "<localleader>lv", "<cmd>VimtexView<CR>",        desc = "LaTeX: view PDF" },
    { "<localleader>lc", "<cmd>VimtexClean<CR>",       desc = "LaTeX: clean aux" },
    { "<localleader>le", "<cmd>VimtexErrors<CR>",      desc = "LaTeX: errors" },
    { "<localleader>ls", "<cmd>VimtexStatus<CR>",      desc = "LaTeX: status" },
  },
}
