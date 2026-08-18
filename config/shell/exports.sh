# Shared environment. Sourced from bashrc.
export EDITOR=nvim
export VISUAL=nvim
export PATH="$HOME/.local/bin:$PATH"

# XDG (see 03-conventions/filesystem-layout.md)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Machine-specific, linked by dotbot. Guarded so a fresh clone works
# before the machine profile has been applied.
[ -r "$HOME/.config/shell/local.sh" ] && . "$HOME/.config/shell/local.sh"
