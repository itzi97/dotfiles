# Check for hostname to apply hidpi settings
if [[ "$(hostname)" = "itzi-yoga-ubuntu" ||
      "$(hostname)" = "itzi-yoga-nixos" ]]; then

    # Unlock gnome-keyring if not a desktop environment
    if [[ "${DESKTOP_SESSION}" != "gnome" &&
          "${DESKTOP_SESSION}" != "cinnamon" ]];then
        eval $(gnome-keyring-daemon --start)
        export SSH_AUTH_SOCK

        # Set gnome as desktop environment
        export DE="gnome"

        # HighDPI Settings
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export GDK_SCALE=2
        export GDK_DPI_SCALE=0.5
    fi
fi


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

# Java
export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"

# R
export R_ENVIRON_USER="${HOME}/.config/R/.Renviron"

# Flatpak
export PATH="/var/lib/flatpak/exports/bin:${PATH}"

# Formatter paths
export UNCRUSTIFY_CONFIG="${HOME}/.config/uncrustify/uncrustify.cfg"

# Nix
if [ -e /home/itziar/.nix-profile/etc/profile.d/nix.sh ];
    then . /home/itziar/.nix-profile/etc/profile.d/nix.sh;
fi

# Perl
export PATH="${HOME}/.local/share/perl5/bin${PATH:+:${PATH}}";
export PERL5LIB="${HOME}/.local/share/perl5/lib/perl5";
export PERL_LOCAL_LIB_ROOT="${HOME}/.local/share/perl5";
export PERL_MB_OPT="--install_base \"${HOME}/.local/share/perl5\"";
export PERL_MM_OPT="INSTALL_BASE=${HOME}/.local/share/perl5";