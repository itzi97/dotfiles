# Check for hostname to apply hidpi settings
resolution=$(xrandr | grep -i '*' | awk '{print $1}' | awk 'BEGIN {FS="x"} {print $1}')

if [[ "${resolution}" = "3840" ]]; then
	# Unlock gnome-keyring if not a desktop environment
	if [[ "${DESKTOP_SESSION}" != "gnome" &&
		"${DESKTOP_SESSION}" != "cinnamon" ]];then

	eval $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
	#export $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
	#dbus-update-activation-environment --systemd DISPLAY
	export SSH_AUTH_SOCK

		# Set gnome as desktop environment
		export DE=gnome

		# HighDPI Settings
		export QT_AUTO_SCREEN_SCALE_FACTOR=1
		export GDK_SCALE=2
		export GDK_DPI_SCALE=0.5
		export ELM_SCALE=2
	fi
fi

# Default programs
export EDITOR=nvim
export PDFVIEWER=evince
if [ -n "$DISPLAY" ]; then
	export BROWSER=brave
else
	export BROWSER=links
fi

# Default Programs

export WORKSPACE="${HOME}/Workspace"

# Add local path
export PATH="${PATH}:${HOME}/.local/bin"

# Add Rust path
export PATH="${PATH}:${HOME}/.cargo/bin"

# Go path
export GOPATH="${WORKSPACE}/go"
export GOBIN="${GOPATH}/bin"
export PATH="${PATH}:${GOBIN}"

# Jupyter path
export JUPYTERLAB_DIR="${HOME}/.local/share/jupyter/lab"

# R
export R_ENVIRON_USER="${HOME}/.config/R/.Renviron"

# Flatpak
export PATH="/var/lib/flatpak/exports/bin:${PATH}"

# Nix
if [ -e /home/itziar/.nix-profile/etc/profile.d/nix.sh ]; then
	. /home/itziar/.nix-profile/etc/profile.d/nix.sh;
fi

# Perl
export PATH="${HOME}/.local/share/perl5/bin${PATH:+:${PATH}}";
export PERL5LIB="${HOME}/.local/share/perl5/lib/perl5";
export PERL_LOCAL_LIB_ROOT="${HOME}/.local/share/perl5";
export PERL_MB_OPT="--install_base \"${HOME}/.local/share/perl5\"";
export PERL_MM_OPT="INSTALL_BASE=${HOME}/.local/share/perl5";

# Hadoop
export HADOOP_CONF_DIR="/etc/hadoop"
export HADOOP_LOG_DIR="/tmp/hadoop/log"
export HADOOP_WORKERS="/etc/hadoop/workers"
export HADOOP_PID_DIR="/tmp/hadoop/run"

# Spark
export SPARK_HOME="/opt/apache-spark"
export PATH="${PATH}:${SPARK_HOME}/bin"

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS="lab"

# Source private keys
source ~/.zsh/private.zsh
