# Edit this configuration file to define what should be installed on your system.  Help is available in the 
# configuration.nix(5) man page and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  boot.loader = {
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
      # Use OSProber
      useOSProber = true;
      version = 2;
    };
  };
  

  networking.hostName = "itzi-yoga-nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here. Per-interface useDHCP will be mandatory in 
  # the future, so this generated config replicates the default behaviour.
  networking.useDHCP = false; 
  networking.interfaces.wlp107s0.useDHCP = true;

  # Configure network proxy if necessary networking.proxy.default = "http://user:password@proxy:port/"; 
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties. 
  i18n.defaultLocale = "en_US.UTF-8"; console = {
    font = "Lat2-Terminus16"; 
    keyMap = "us";
  };

  # Set your time zone. 
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run: $ nix search wget 
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Applications
    appimage-run
    mpv
    mpd
    ncmpcpp
    neomutt
    thunderbird

    # Gaming
    dolphinEmu
    steam
    vbam
    wineFull
    winetricks

    # Browsers
    firefox 
    vivaldi

    # Chatting
    discord
    discord-rpc

    # Coding
    arduino
    kitty
    tmux
    neovim
    nodejs
    vim 
    zsh

    # Gnome
    gnome3.evolution
    gnome3.gnome-boxes
    gnome3.gnome-tweaks
    gnome3.gnome-shell-extensions
    gnome3.gnome-software

    # Languages

    # Rust
    cargo
    rustfmt

    # C, C++, Objective C
    gcc
    clang
    clang-analyzer
    clang-manpages
    clang-tools
    ccls
    llvmPackages.libclang

    # Go
    go

    # LaTeX
    texlive.combined.scheme-full

    # Java
    openjdk8
    openjdk11 
    openjdk12

    # Ruby
    ruby

    # Formatters
    astyle

    # Window Manager Stuff
    dunst
    feh
    lxappearance
    nitrogen
    picom
    polybar

    # Themes
    arc-theme
    capitaine-cursors
    canta-theme
    gnome-breeze
    gnome-themes-extra
    numix-gtk-theme
    papirus-icon-theme

    # Utilities
    curl
    git 
    grsync
    htop
    neofetch
    nerdfonts
    wget
  ];

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
    theme = "agnoster";
    customPkgs = with pkgs; [
      pkgs.nix-zsh-completions
    ];
  };
  
  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions. programs.mtr.enable = true; 
  programs.gnupg.agent = {
    enable = true; 
    enableSSHSupport = true; 
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ]; 
  # Or disable the firewall altogether.
  # networking.firewall.enable = true;

  # Enable CUPS to print documents. 
  services.printing.enable = true;

  # Enable sound. 
  sound.enable = true; 
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing 
  services.xserver.enable = true; 
  services.xserver.layout = "es"; 
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support. 
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment. 
  services.xserver = {
    displayManager.lightdm.enable = true; 
    desktopManager.gnome3.enable = true;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmobar
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’. 
  users.users.itziar = {
    isNormalUser = true; 
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release from which the default settings for stateful data, like file locations and database 
  # versions on your system were taken. It‘s perfectly fine and recommended to leave this value at the release version of the 
  # first install of this system. Before changing this value read the documentation for this option (e.g. man configuration.nix 
  # or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
