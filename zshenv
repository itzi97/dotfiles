# Unlock gnome-keyring if not a desktop environment
if [ -n "$DESKTOP_SESSION" ];then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK

    # HighDPI Settings
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export GDK_SCALE=2
    export GDK_DPI_SCALE=0.5
fi

# Set gnome as desktop environment
export DE="gnome"

# Default programs
export EDITOR="nvim"
if [ -n "$DISPLAY" ]; then
    export BROWSER=firefox
else
    export BROWSER=links
fi


# Default Programs

# Add local path
export PATH="${PATH}:${HOME}/.local/bin"

# Add Rust path
export PATH="${PATH}:${HOME}/.cargo/bin"

# Go path
export GOPATH="${HOME}/.go"
export PATH="${PATH}:${GOPATH}/bin"

# R
export R_ENVIRON_USER="${HOME}/.config/r/.Renviron"
