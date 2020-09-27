# vim: set foldmethod=marker:
# -----------------------------------------------------------------------------
#  _   _  ____  ____
# | \ | ||_  _|| __ |
# |  \| |  ||   \\//
# | |\  | _||_  //\\
# |_| \_||____||____|
# -----------------------------------------------------------------------------
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 
  # {{{ Boot & OS

  # Intel processor.
  hardware.cpu.intel.updateMicrocode = true;

  # Allow non-free packages.
  nixpkgs.config.allowUnfree = true;

  boot = {
    # Use GRUB EFI boot loader.
    loader = {
      efi = {
        canTouchEfiVariables = true;
        # assuming /boot is the mount point of the  EFI partition in NixOS (as the installation section recommends).
        efiSysMountPoint = "/boot";
      };
      grub = {
        # despite what the configuration.nix manpage seems to indicate,
        # as of release 17.09, setting device to "nodev" will still call
        # `grub-install` if efiSupport is true
        # (the devices list is not used by the EFI grub install,
        # but must be set to some value in order to pass an assert in grub.nix)
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
         # set $FS_UUID to the UUID of the EFI partition
        extraEntries = ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root $FS_UUID
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
        font = "${pkgs.terminus_font_ttf}/share/fonts/truetype/TerminusTTF.ttf";
        fontSize = 32; # For HiDPI
        #theme = "${pkgs.nixos-grub2-theme}";
        useOSProber = true;
        version = 2;
      };
    };

    # Use plymouth boot splash screen.
    plymouth = {
      enable = true;
    };

    # Kernel extra modules
    kernelPackages = pkgs.linuxPackages_latest;
    # extraModulePackages = with pkgs.linuxPackages; [ wireguard ];
    extraModulePackages = with config.boot.kernelPackages; [ pkgs.wireguard ];
    kernelParams = [ "quiet loglevel=3 splash" ];
  };

  # Automatic Upgrades
  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
    channel = https://nixos.org/channels/nixos-20.09;
  }; 
  # }}}

  # {{{ Networking
  networking = {
    hostName = "itzi-yoga-nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp107s0.useDHCP = true;
    enableIPv6 = false; # Due to PIA vpn.

    # NetworkManager enabling with OpenVPN and Wireguard support.
    networkmanager= {
      enable = true;
      wifi.powersave = true;
      packages = with pkgs; [
        networkmanager-openvpn
      ];
    };

    # Wireguard VPN.
    wireguard = {
      enable = true; 
    };
  };

  #services.openvpn.servers = {
   # Spain.authUserPass = {
   #   username = "p3583275";
   #   password = "U6Fvg3EHTD";
   # };
    #Albania = { config = '' config /etc/openvpn/client/Albania.conf ''; };
    #Belgium = { config = '' config /etc/openvpn/client/Belgium.conf ''; };
    #DE_Berlin = { config = '' config /etc/openvpn/client/DE_Berlin.conf ''; };
    #Denmark = { config = '' config /etc/openvpn/client/Denmark.conf ''; };
    #Estonia = { config = '' config /etc/openvpn/client/Estonia.conf ''; };
    #Finland = { config = '' config /etc/openvpn/client/Finland.conf ''; };
    #France = { config = '' config /etc/openvpn/client/France.conf ''; };
    #Greece = { config = '' config /etc/openvpn/client/Greece.conf ''; };
    #Hungary = { config = '' config /etc/openvpn/client/Hungary.conf ''; };
    #Iceland = { config = '' config /etc/openvpn/client/Iceland.conf ''; };
    #India = { config = '' config /etc/openvpn/client/India.conf ''; };
    #Ireland = { config = '' config /etc/openvpn/client/Ireland.conf ''; };
    #Israel = { config = '' config /etc/openvpn/client/Israel.conf ''; };
    #Italy = { config = '' config /etc/openvpn/client/Italy.conf ''; };
    #Japan = { config = '' config /etc/openvpn/client/Japan.conf ''; };
    #Latvia = { config = '' config /etc/openvpn/client/Latvia.conf ''; };
    #Lithuania = { config = '' config /etc/openvpn/client/Lithuania.conf ''; };
    #Luxembourg = { config = '' config /etc/openvpn/client/Luxembourg.conf ''; };
    #Moldova = { config = '' config /etc/openvpn/client/Moldova.conf ''; };
    #Netherlands = { config = '' config /etc/openvpn/client/Netherlands.conf ''; };
    #New_Zealand = { config = '' config /etc/openvpn/client/New_Zealand.conf ''; };
    #North_Macedonia = { config = '' config /etc/openvpn/client/North_Macedonia.conf ''; };
    #Norway = { config = '' config /etc/openvpn/client/Norway.conf ''; };
    #Poland = { config = '' config /etc/openvpn/client/Poland.conf ''; };
    #Portugal = { config = '' config /etc/openvpn/client/Portugal.conf ''; };
    #Romania = { config = '' config /etc/openvpn/client/Romania.conf ''; };
    #Serbia = { config = '' config /etc/openvpn/client/Serbia.conf ''; };
    #Singapore = { config = '' config /etc/openvpn/client/Singapore.conf ''; };
    #Slovakia = { config = '' config /etc/openvpn/client/Slovakia.conf ''; };
    #South_Africa = { config = '' config /etc/openvpn/client/South_Africa.conf ''; };
    #Spain = { config = '' config /etc/openvpn/client/Spain.conf ''; };
    #Switzerland = { config = '' config /etc/openvpn/client/Switzerland.conf ''; };
    #Turkey = { config = '' config /etc/openvpn/client/Turkey.conf ''; };
    #UAE = { config = '' config /etc/openvpn/client/UAE.conf ''; };
    #UK_London = { config = '' config /etc/openvpn/client/UK_London.conf ''; };
    #US_California = { config = '' config /etc/openvpn/client/US_California.conf ''; };
    #US_Florida = { config = '' config /etc/openvpn/client/US_Florida.conf ''; };
    #US_New_York_City = { config = '' config /etc/openvpn/client/US_New_York_City.conf ''; };
  #};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # }}}

  # {{{ Locale
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "es";
  };

  # Set your time zone.
  time.timeZone = "Europe/Madrid";
  # }}}

  # {{{ Packages
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    # {{{ Desktop Apps
    
    _1password-gui
    alacritty
    discord
    firefox
    gitkraken
    megasync
    thunderbird
    spotify
    steam

    # Image Tools
    appimage-run
    appimageTools

    # }}}
    # {{{ Editors
    
    neovim
    neovim-remote
    vim

    # }}} 
    # {{{ Gnome

    gnome3.gnome-tweaks
    gnomeExtensions.appindicator
    #gnomeExtensions.battery-status - broken
    gnomeExtensions.caffeine
    gnomeExtensions.dash-to-dock
    #gnomeExtensions.topicons-plus - broken

    # }}}
    # {{{ IDEs
    
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.pycharm-community

    # RStudio
    (rstudioWrapper.override {
      packages = with rPackages; [
        devtools 
        dplyr 
        ggplot2 
        mosaic 
        reticulate 
        rmarkdown 
        xts
      ];
    })

    # }}}
    # {{{ Programming
    
    texlive.combined.scheme-full

    # Compiling
    gnumake
    cmake

    # C/C++
    ccls
    clang
    clang-tools
    gcc
    llvm

    # Go
    go
    go-tools
    go-check

    # Python
    (python3.withPackages (ps: with ps; [ 
      flask
      numpy 
      pandas 
      pynvim
      simpy 
    ]))

    # R
    (rWrapper.override {
      packages = with rPackages; [ 
        devtools 
        mosaic
        reticulate
      ];
    })
    
    # Rust
    cargo
    rust-analyzer
    rustc
    rustfmt
    rustup

    # NodeJS
    nodejs
    nodePackages.neovim
    nodePackages.create-react-app
    nodePackages.react-tools
    nodePackages.react-native-cli

    # Octave
    octaveFull

    # }}}
    # {{{ Terminal tools

    _1password
    bc
    bpytop
    curl
    git
    gitAndTools.gh
    killall
    jq
    htop
    lsd
    megatools
    neofetch
    pandoc
    ranger
    tmux
    unzip
    wget
    xclip
    xorg.xev
    xorg.xmodmap
    xorg.setxkbmap

    # }}}
    # {{{ Themes
    
    arc-theme
    capitaine-cursors
    papirus-icon-theme

    # }}}
    # {{{ Services
    
    openvpn
    wg-bond
    wireguard-tools    

    # }}}
    # {{{ Window Manager Tools
    
    acpilight
    dunst
    flameshot
    inotify-tools
    lxappearance
    nitrogen
    networkmanagerapplet
    pasystray
    picom
    polybar
    rofi
    xmonad-log

    # }}}
  ];

  # {{{ SUID wrappers
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
  # }}}

  # {{{ Fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    hack-font
    fira-code
    fira-code-symbols
    roboto
    roboto-mono
    terminus_font_ttf
    weather-icons
  ];
  # }}}

  # }}}

  # {{{ Programs

  # Set Vim as default editor.
  programs.vim.defaultEditor = true;
  
  # {{{ ZSH
  # Enable zsh as default user shell for root and other users.
  programs.zsh = {
    enable = true;
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    shellAliases = {
      ls = "lsd";
      btop = "bpytop";
    };
    autosuggestions.enable = true;
    enableBashCompletion = true;
    syntaxHighlighting.enable = true;
    # Use OhMyZsh as plugin manager.
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "github"
        "sudo"
        "tmux"
        "tmuxinator"
        "vi-mode"
      ];
      #theme = "powerlevel10k/powerlevel10k"; - not working
      customPkgs = with pkgs; [
        pkgs.nix-zsh-completions
        pkgs.zsh-powerlevel10k
      ];
    };
  };
  # }}}

  # {{{ Tmux
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    newSession = true; 
    terminal = "screen-256color";
  };
  
  # }}}

  # {{{ VirtualBox
  #virtualisation.virtualbox = {
  #  host = {
  #    enable = true;
  #    enableExtensionPack = true;
  #  };
  #  #guest.enable = true;
  #};
  # }}}

  # }}}

  # {{{ Services

  # Enable Flatpak service.
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 80 433 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable TLP for better battery management.
  services.tlp.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # {{{ Sound
  # Enable sound.
  sound = {
    enable = true;
    #extraConfig = "options snd-hda-intel dmic_detect=0";
  };
  #sound.mediaKeys = {
  #  enable = true;
  #  volumeStep = "5%";
  #};
  hardware.pulseaudio = {
    enable = true;
    
    # Bluetooth support.
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };
  # }}}

  # Enable user control of backlight.
  hardware.acpilight.enable = true;
  programs.light.enable = true;

  # Enable bluetooth.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # {{{ X11
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    
    # Keyboard.
    layout = "es";
    xkbVariant = "winkeys";
    xkbOptions = "eurosign:e";
    #extraLayouts.media = {
    #  description  = "Multimedia keys remapping";
    #  languages    = [ "es" ];
    #  symbolsFile  = /etc/nixos/keyboard/media-sym;
    #  keycodesFile = /etc/nixos/keyboard/media-key;
    #};

    # Video.
    videoDrivers = [ "i915" ];
    
    # Touchscreen.
    wacom.enable = true;

    # Enable touchpad support.
    libinput = {
      enable = true;
      tapping = true;
      clickMethod = "buttonareas";
      disableWhileTyping = true;
    };
  };
  
  # }}}

  # {{{ MySQL

  #services.mysql = {
  #  enable = true;
  #  user = "itziar";
  #  package = pkgs.mariadb;
  #};

  # }}}

  # }}}

  # {{{ Desktop Environment

  # Enable the Gnome Desktop Environment, gdm and XMonad.
  services.xserver.displayManager.sessionCommands = "setxkbmap -keycodes media";
  services.xserver.displayManager.gdm.enable = true;

  # Gnome
  services.xserver.desktopManager.gnome3.enable = true;

  # XMonad
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = haskellPackages: [
      # Base packages.
      haskellPackages.xmonad-contrib
      haskellPackages.xmonad-extras
      haskellPackages.xmonad
      haskellPackages.monad-logger

      # Extra packages for X11 and DBus support.
      haskellPackages.dbus
      haskellPackages.X11
    ];
  };

  # Gnome3 Configuration
  services.gnome3 = {
    chrome-gnome-shell.enable = true;
    gnome-user-share.enable = true;
    gnome-keyring.enable = true;
    gnome-online-accounts.enable = true;
    sushi.enable = true;
  };

  # Ensure system trya in Gnome.
  services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  # }}}
  
  # {{{ User Configuration

  # Allow configuration of users outside of NixOS configuration.
  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;

    # Owner a user account.
    users.itziar = {
      isNormalUser = true;
      home = "/home/itziar";
      description = "Itziar";
      extraGroups = [ "wheel" "networkmanager" "video" "vboxusers" ]; # Enable ‘sudo’ for the user.
    };
  };

  # }}}

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}

