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

-- Colourschemes we have already complained about, so the warning below is said
-- once per name per session rather than once per filesystem event.
M._warned = {}

--- Apply it. Safe to call repeatedly; does nothing if already correct.
function M.apply()
  local want = M.colorscheme()
  if vim.g.colors_name == want then return end
  if pcall(vim.cmd.colorscheme, want) then return end

  -- The mapped scheme is not installed (fresh clone before :Lazy sync, or a
  -- plugin that failed to build). Never leave the editor on nvim's default —
  -- but do not degrade silently either.
  --
  -- This used to be a bare pcall with no message. That made a real breakage
  -- (wrong plugin name, failed build, scheme deleted upstream) indistinguishable
  -- from normal operation: you'd get gruvbox, which is exactly what you'd get if
  -- everything were fine and the session theme were gruvbox-crt. Degrading
  -- quietly is the goal on a machine that must not fail during a deadline; it
  -- should still be possible to find out that it happened.
  if not M._warned[want] then
    M._warned[want] = true
    vim.schedule(function()
      vim.notify(
        ("theme: colourscheme %q is not installed — using %q. Try :Lazy sync.")
          :format(want, M.fallback),
        vim.log.levels.WARN
      )
    end)
  end
  pcall(vim.cmd.colorscheme, M.fallback)
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
--
-- ON THE fname FILTER. libuv does not populate the filename argument on every
-- backend, so `fname` can arrive as nil for a perfectly real change. The filter
-- therefore has to let nil through, which means an unrelated write anywhere in
-- the directory can wake us. Checked rather than left as a worry: the only cost
-- is calling M.apply() a few extra times per switch, and M.apply() returns on
-- its first line when vim.g.colors_name already matches. Wart, not bug — kept,
-- because the alternative (polling, or nothing) is worse for the thing this is
-- actually for, which is the theme changing under an editor that is already open.
--
-- ON STORING THE HANDLE. M._watcher exists so there is something to stop and
-- something to inspect, NOT to keep the handle alive. That was worth checking
-- before writing it down, and the answer is that a plain local would have been
-- fine: luv refs every handle into the Lua registry when it is created and only
-- releases it on close (luv src/lhandle.c), so an unreferenced-but-active
-- watcher does not get collected. The early return also makes a second
-- watch() call a no-op instead of a leaked handle.
function M.watch()
  if M._watcher then return end
  local uv = vim.uv or vim.loop
  if not uv then return end
  local dir = STATE:match("^(.*)/[^/]*$")
  if not dir then return end
  local ok, handle = pcall(uv.new_fs_event)
  if not ok or not handle then return end
  local started = pcall(function()
    handle:start(dir, {}, function(err, fname)
      if err then return end
      if fname and fname ~= "name" then return end
      -- Back onto the main loop: touching vim.* from a libuv callback is not
      -- allowed and crashes rather than misbehaving.
      vim.schedule(function() M.apply() end)
    end)
  end)
  if not started then
    pcall(function() handle:close() end)
    return
  end
  M._watcher = handle
end

return M
