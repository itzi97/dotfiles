-- ~/.dotfiles/config/nvim/init.lua
-- Linked wholesale to ~/.config/nvim by install.conf.yaml — including
-- lazy-lock.json, which we WANT tracked so plugin versions are pinned in git.
--
-- Structure, and why it isn't one file:
--   lua/config/   editor behaviour that has nothing to do with plugins
--   lua/plugins/  one file per concern, each loaded automatically by lazy.nvim
--
-- kickstart.nvim is a single file on purpose — it's meant to be read top to
-- bottom once. This is kickstart's content with kickstart's comments, split up,
-- because the goal here is different: every future change should be a small
-- commit touching one file, which can be reverted alone when it turns out to
-- be a bad idea. See 02-stack/neovim-config-comparison.md for why not LazyVim.
--
-- There is no upstream. This is your config now; edit it directly.

-- Leader must be set before lazy.nvim loads, or plugin keymaps bind to the
-- wrong key. This is the one ordering constraint in the whole config.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.lazy")
require("config.keymaps")

-- Follow the Hyprland session theme (ADR-0026). AFTER config.lazy, because
-- both colourschemes must be installed before one can be chosen; neither
-- plugin spec applies itself, so this is the only place a colourscheme is set
-- and there is no last-one-wins race between them.
local theme = require("config.theme")
theme.apply()
theme.watch()
vim.api.nvim_create_user_command("SessionTheme", theme.reload,
  { desc = "Re-read the session theme and re-apply the colourscheme" })

-- Machine-specific overrides, if any. pcall so a missing file is not fatal —
-- the same guard the placeholder config had, kept deliberately.
pcall(require, "local")
