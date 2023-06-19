# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';

      # cosmetics
      fontSize = 36;
      backgroundColor = "#5c6a57";
      splashImage = ./origami.png;
      splashMode = "normal";
    };
  };

  virtualisation.docker.enable = true;

  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.hostName = "crockpot";

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
   console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.defaultSession = "none+qtile";
  services.xserver.windowManager.qtile = {
    enable = true;
    backend = "x11";
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
    ];
  };

  # Enable the Plasma 5 Desktop Environment.  
  services.xserver.desktopManager.plasma5 = {
    enable = true;
  };

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    oxygen
    konsole
  ];
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:swapescape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Scanner
  hardware.sane.enable = true;
  # services.ipp-usb.enable=true;

  # wacom
  services.xserver.wacom.enable = true;
  # hardware.opentabletdriver.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kasuari = {
    createHome = true;
    home = "/home/kasuari";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "disk" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
    ];

    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  
  environment.systemPackages = with pkgs; [
    acpilight
    coreutils
    btop 
    pkgs.libinput-gestures
    git 
    networkmanagerapplet
    neovim 
    nix
    nix-prefetch-scripts
    home-manager
    tmux 
    wget
    which 
    zsh

    # archive helper
    atool     # easy zip unzip
    unzip
    zip
    libarchive
    p7zip

    nixos-option

    qtile
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.git.enable = true;
  programs.git.config = {
    init = {
      defaultBranch = "main";
    };

    core = {
      editor = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ sensible vim-nix ];
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      la = "ls -la";
    };

    setOptions = [
      "HIST_IGNORE_DUPS"
      "SHARE_HISTORY"
      "HIST_FCNTL_LOCK"
      "RM_STAR_WAIT"
      "VI"
    ];
  };

  # set default editor to neovim
  environment.variables.EDITOR = "nvim";

  # List services that you want to enable:

  # run XDGAutostart even if there is no DE
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Allow user in `video` group to change brightness without sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # wait time to hibernate for 'suspend-then-hibernate' config
  systemd.sleep.extraConfig = "HibernateDelaySec=30min";

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "suspend-then-hibernate"; # lid closed but another screen is connected
    lidSwitchExternalPower = "lock";

    # After screen is locked, it waits until 20min of idle to 'suspend-then-hibernate'
    # combined with services.screen-locker in home-manager,
    # this will result in:  10m -> lock -> 10m -> suspend -> 30m -> hibernate
    extraConfig = "
      IdleAction=suspend-then-hibernate
      IdleActionSec=20min
    ";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "22.11"; # Did you read the comment?
  system.stateVersion = "23.05"; # Did you read the comment?

}

