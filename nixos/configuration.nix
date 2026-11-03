# TODO: remove X11 configs
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./manual-hardware.nix
    ./desktop.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.substituters = [
    # mainland chinese, mostly stable version
    # "https://mirror.nju.edu.cn/nix-channels/store"
    # "https://mirrors.cernet.edu.cn/nix-channels/store"
    # "https://mirrors.ustc.edu.cn/nix-channels/store"
    # "https://mirror.sjtu.edu.cn/nix-channels/store" # slow

    # original
    "https://cache.nixos.org/"
  ];

  # set default editor to neovim
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kasuari = {
    createHome = true;
    home = "/home/kasuari";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "disk"
      "docker"
      "input"
      "uinput"
    ]; # Enable ‘sudo’ for the user.

    packages = with pkgs; [
      firefox
      xf86-video-amdgpu
    ];

    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    # basics
    coreutils
    tmux
    wget
    which
    killall
    gparted

    # nice to have
    ncdu
    btop

    # nix tools
    nix
    nix-prefetch-scripts
    home-manager
    nixos-option

    # archive helper
    atool # easy zip unzip
    unzip
    zip
    libarchive
    p7zip

    nssTools # required by caddy
    qpwgraph # pipewire gui
    exfatprogs #TODO review
  ];

  fonts.packages = with pkgs; [
    newcomputermodern
    lmmath
    wqy_zenhei
    wqy_microhei

    cantarell-fonts # Used by regreet
  ];

  programs.captive-browser = {
    enable = true;
    interface = "wlp3s0";
  };

  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };

  programs.bandwhich.enable = true;
  programs.git = {
    enable = true;
    config = {
      init = {
        defaultBranch = "main";
      };

      core = {
        editor = "nvim";
      };
    };
  };

  programs.neovim = {
    enable = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
          vim-sensible
          vim-nix
        ];
      };
    };
  };

  # Nix helper
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 10 --keep-since 7d";
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

  # ------- Thunar related
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      debug
    '';

    logFormat = ''
      level DEBUG
    '';

    virtualHosts."dash.localhost".extraConfig = ''
      tls internal
      root /srv/dash
      file_server
    '';
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      registry-mirrors = [
        "https://docker.mirrors.sjtug.sjtu.edu.cn"
        "https://docker.mirrors.ustc.edu.cn"
        "https://registry.docker-cn.com"
      ];
    };
  };

  # ==================== WARNING
  # ==================== LOW LEVEL STUFF

  # Power Management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 0;
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth";
    };
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  # TODO: package this
  environment.etc."wallpapers/kumamon.png" = {
    source = pkgs.fetchurl {
      url = "https://f003.backblazeb2.com/file/squirrel-stash/wallpapers/kumamon.png";
      hash = "sha256-A0x4VbfRuPY6b6d/L/N9k9xIsoIjEeFgzyFkfvcYanc";
    };
  };

  # Might be useful: https://askubuntu.com/questions/916465/ubuntu-17-04-keyboard-not-responding-after-suspend
  # https://unix.stackexchange.com/questions/28736/what-does-the-i8042-nomux-1-kernel-option-do-during-booting-of-ubuntu
  # https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt
  boot.kernelParams = [
    "quiet"
    "splash"
    "usbcore.autosuspend=-1"

    # limit the processor to shallow sleep state to avoid random freeze
    # https://en.wikipedia.org/wiki/ACPI#CPU_states
    "processor.max_cstate=1"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = ["ntfs"];
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
      backgroundColor = "#141414";
      splashImage = config.environment.etc."wallpapers/kumamon.png".source;
      splashMode = "normal";
    };
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;

  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Allow user in `video` group to change brightness without sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # Pick only one of the below networking options.
  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;
  networking.hostName = "crockpot";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # networking.nameservers = ["1.1.1.1" "9.9.9.9"];
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      3000
      8000
      8080
      12345
      # Localsend
      53317
    ];
  };

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
