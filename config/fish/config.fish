# ~/.config/fish/config.fish  (linked from ~/.dotfiles/config/fish/config.fish)
#
# fish is the interactive shell; bash stays the LOGIN shell and hands off via
# `exec fish` at the end of ~/.bashrc — see ADR-0010. That ordering matters:
# by the time this file runs, /etc/profile and /etc/profile.d/*.sh have already
# been read by bash, so PATH is correct. Do not re-do that work here.

# --- environment (every fish, interactive or not) -------------------------
set -gx EDITOR nvim
set -gx VISUAL nvim

# Idempotent: prepends only if not already present, so the exec-from-bash
# handoff can't duplicate entries.
fish_add_path -g "$HOME/.local/bin"

# XDG (see 03-conventions/filesystem-layout.md). Only set if the parent
# environment didn't already.
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -q XDG_DATA_HOME;   or set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -q XDG_STATE_HOME;  or set -gx XDG_STATE_HOME  "$HOME/.local/state"
set -q XDG_CACHE_HOME;  or set -gx XDG_CACHE_HOME  "$HOME/.cache"

# Machine-specific fragment, linked by dotbot from local/<machine>/local.fish.
# Guarded so a fresh clone works before the machine profile has been applied.
test -r "$HOME/.config/fish/local.fish"; and source "$HOME/.config/fish/local.fish"

# --- interactive only -----------------------------------------------------
if status is-interactive
    set -g fish_greeting

    alias ll 'ls -lah'
    alias vim nvim
    alias g git
    alias dotfiles 'cd ~/.dotfiles'
end
