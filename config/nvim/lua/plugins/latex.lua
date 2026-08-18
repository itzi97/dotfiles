-- LaTeX — the CV, and coursework reports.
--
-- This is the addition that makes the config yours rather than generic, and
-- there are two machine-specific details worth understanding before changing
-- anything here.
--
-- 1. COMPILER. vimtex shells out to `latexmk`. On this machine latexmk is NOT
--    installed on the host — it lives in the `uni` distrobox and reaches the
--    host as an exported wrapper in ~/.local/bin (ADR-0012, toolboxes/uni.txt).
--    That works because the box shares $HOME, so the container sees the same
--    .tex file at the same path and writes the PDF back where you expect.
--
--    It also means: if `tbx rm uni` ever happens, LaTeX compilation stops
--    working here and the error will be a confusing "latexmk not found" rather
--    than anything mentioning containers. `tbx create uni` fixes it.
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
--    Forward search across the container boundary works because the *viewer*
--    runs on the host. Only the compiler is containerised.

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
