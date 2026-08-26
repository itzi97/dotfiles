-- Session theme → colourscheme.
--
-- The Hyprland session can be switched between whole visual identities with
-- `hypr-theme` (ADR-0026), and this is how the editor follows. The active
-- theme's NAME is a one-line file written by that script:
--
--   ~/.local/state/hypr-theme/name
--
-- WHY READ A FILE RATHER THAN AN ENVIRONMENT VARIABLE. nvim inherits the
-- environment of whatever spawned it, which is usually a kitty started before
-- the last theme switch. An env var would make the editor's colours depend on
-- how old its terminal is. The file is always current.
--
-- WHY THIS DEGRADES QUIETLY. nvim runs on the ThinkPad during deadlines, over
-- ssh, and inside distrobox containers where the file does not exist at all.
-- Every failure path here ends at gruvbox rather than at an error: no file,
-- unreadable file, unknown theme name, or a colourscheme that failed to
-- install all resolve to the same working editor.

local M = {}

local STATE = (vim.env.XDG_STATE_HOME or ((vim.env.HOME or "") .. "/.local/state"))
  .. "/hypr-theme/name"

-- Session theme name → colourscheme name. A theme with no entry falls back,
-- which is the right behaviour for a theme that does not care about the editor.
M.map = {
  ["gruvbox-crt"] = "gruvbox",
  ["neon-sprawl"] = "silkcircuit",
}

M.fallback = "gruvbox"

--- Name of the active session theme, or nil if there isn't one.
function M.session()
  local f = io.open(STATE, "r")
  if not f then return nil end
  local line = f:read("l")
  f:close()
  if not line then return nil end
  line = line:gsub("%s+$", "")
  return line ~= "" and line or nil
end

--- Colourscheme this session should be using.
function M.colorscheme()
  local s = M.session()
  return (s and M.map[s]) or M.fallback
end

--- Apply it. Safe to call repeatedly; does nothing if already correct.
function M.apply()
  local want = M.colorscheme()
  if vim.g.colors_name == want then return end
  if not pcall(vim.cmd.colorscheme, want) then
    -- The mapped scheme is not installed (fresh clone before :Lazy sync, or a
    -- plugin that failed to build). Never leave the editor on nvim's default.
    pcall(vim.cmd.colorscheme, M.fallback)
  end
end

--- Re-read the file and apply, for an nvim that was already open when the
--- session theme changed. Bound to :SessionTheme, and also wired to a file
--- watcher below so it usually happens by itself.
function M.reload()
  M.apply()
  vim.notify("theme: " .. (M.session() or "none") .. " → " .. (vim.g.colors_name or "?"))
end

-- Live switching for ALREADY-OPEN editors.
--
-- libuv watches the state directory rather than the file itself: hypr-theme
-- rewrites `name` by truncating and writing, and some editors/tools replace
-- files by rename — a watch on the inode would survive the first but miss the
-- second. Watching the directory catches both.
--
-- Entirely optional. Wrapped in pcall because vim.uv is 0.10+ (vim.loop
-- before that) and because a failed watcher must never stop nvim from opening.
function M.watch()
  local uv = vim.uv or vim.loop
  if not uv then return end
  local dir = STATE:match("^(.*)/[^/]*$")
  if not dir then return end
  local ok, handle = pcall(uv.new_fs_event)
  if not ok or not handle then return end
  pcall(function()
    handle:start(dir, {}, function(err, fname)
      if err then return end
      if fname and fname ~= "name" then return end
      -- Back onto the main loop: touching vim.* from a libuv callback is not
      -- allowed and crashes rather than misbehaving.
      vim.schedule(function() M.apply() end)
    end)
  end)
end

return M
