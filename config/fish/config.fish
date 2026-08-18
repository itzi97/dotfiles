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

    # --- prompt ------------------------------------------------------------
    # starship, shared with bash on purpose. ADR-0010 makes bash the rescue
    # shell, and the rescue shell should look like the one I actually use —
    # I only end up there when something is already wrong. Config lives in
    # config/starship/starship.toml, linked to ~/.config/starship.toml.
    #
    # Guarded: a fresh clone must still give a working shell before
    # bootstrap.sh has installed anything.
    if command -q starship
        starship init fish | source
    end

    # --- vi mode -----------------------------------------------------------
    fish_vi_key_bindings

    # fish draws its own mode indicator to the left of the prompt. starship's
    # character module already shows the mode, so this empties fish's version
    # rather than having both report the same thing in two styles.
    function fish_mode_prompt
    end

    # Cursor shape per mode. Without this the only mode feedback is the prompt
    # symbol at the start of the line, which is easy to miss when the cursor is
    # somewhere in the middle of a long command.
    set -g fish_cursor_default     block
    set -g fish_cursor_insert      line
    set -g fish_cursor_visual      block
    set -g fish_cursor_replace_one underscore

    # Escape is the vi-mode key, so the default 300ms wait for escape sequences
    # makes normal mode feel sluggish. 10ms is enough for real escape sequences
    # from the terminal while feeling instant to a human.
    set -g fish_escape_delay_ms 10
end
