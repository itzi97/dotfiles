-- lazy.nvim bootstrap.
--
-- Clones itself on first start, then loads every file in lua/plugins/. Adding
-- a plugin means adding a file there; nothing needs registering here.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    -- Fail loudly rather than dropping into a config-less editor with no
    -- explanation. Usually this is no network on first run.
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to continue without plugins." },
    }, true, {})
    vim.fn.getchar()
    return
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },

  -- Do NOT auto-check for updates. Plugin versions are pinned in
  -- lazy-lock.json, which is committed, and an update should be a deliberate
  -- act (`:Lazy sync`, then commit the lockfile) rather than something that
  -- happens the morning of a deadline. Principle #2.
  checker = { enabled = false },
  change_detection = { notify = false },

  -- No plugin here needs luarocks, and leaving it enabled leaves a permanent
  -- ❌ in :checkhealth about a hererocks install that will never happen. A
  -- healthcheck with a standing failure is one you stop reading — same reason
  -- pkgwatch's service unit declares SuccessExitStatus=10.
  rocks = { enabled = false },

  install = { colorscheme = { "gruvbox", "habamax" } },

  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin",
      },
    },
  },
})
