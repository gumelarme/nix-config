# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./cachix.nix
  ];

  # steam, fix glxChooseVisual failed
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.substituters = [
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://hyprland.cachix.org"
  ];

  nix.settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

  programs.sway.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "catppuccin-mocha";
  };

  # Might be useful: https://askubuntu.com/questions/916465/ubuntu-17-04-keyboard-not-responding-after-suspend
  # https://unix.stackexchange.com/questions/28736/what-does-the-i8042-nomux-1-kernel-option-do-during-booting-of-ubuntu
  # https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt
  boot.kernelParams = ["quiet" "splash" "usbcore.autosuspend=-1"];

  # Use latest kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

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
      splashImage = config.environment.etc.wallpaper.source;
      splashMode = "normal";
    };
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

  # Pick only one of the below networking options.
  # Easiest to use and most distros use this by default.
  networking.networkmanager.enable = true;
  networking.hostName = "crockpot";

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    #     supportedLocales = [
    #       "en_US.UTF-8/UTF-8"
    #       "zh_CN.UTF-8/UTF-8"
    #     ];

    # extraLocaleSettings = {
    #   LC_CTYPE = "zh_CN.UTF-8";
    # };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  environment.etc.wallpaper = {
    source = pkgs.fetchurl {
      url = "https://f003.backblazeb2.com/file/squirrel-stash/wallpapers/kumamon.png";
      hash = "sha256-A0x4VbfRuPY6b6d/L/N9k9xIsoIjEeFgzyFkfvcYanc";
    };
  };

  services = {
    openssh.enable = true;
    v2raya.enable = true;

    tlp.enable = true;
    tlp.settings = {
      USB_AUTOSUSPEND = 0;
    };

    # Works, but cannot reduce the timeout or bypass to password directly
    # https://github.com/NixOS/nixpkgs/issues/171136
    # https://www.reddit.com/r/Fedora/comments/kx52nz/disable_fingerprint_reader_when_using_sudo/

    fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = pkgs.libfprint-2-tod1-vfs0090;
    };

    kmonad = {
      enable = true;
      keyboards.common-tkl = {
        device = "/dev/input/by-id/usb-026d_0002-event-kbd";
        config = builtins.readFile ./common-tkl.kbd;
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
          compose = {
            key = "ralt";
            delay = 5;
          };
        };
      };
      keyboards.thinkpad = {
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ./thinkpad-t14g2.kbd;
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = false;
          compose = {
            key = "ralt";
            delay = 5;
          };
        };
      };
    };

    libinput.enable = true;
    libinput.mouse.accelSpeed = "1.0";
    libinput.touchpad.accelSpeed = "1.0";

    xserver = {
      enable = true;
      # Configure keymap in X11
      xkb.layout = "us";
      # run XDGAutostart even if there is no DE
      desktopManager.runXdgAutostartIfNone = true;

      desktopManager.xfce = {
        enable = true;
        enableScreensaver = false;
      };

      # windowManager.qtile = {
      #   enable = true;
      #   backend = "x11";
      #   # extraPackages = python3Packages: with python3Packages; [ qtile-extras ];
      # };

      # windowManager.xmonad = {
      #   enable = false;
      #   enableContribAndExtras = true;
      #   extraPackages = hPkgs: [hPkgs.xmobar];
      # };
    };

    logind = {
      lidSwitch = "suspend-then-hibernate";
      lidSwitchDocked = "suspend-then-hibernate"; # lid closed but another screen is connected
      lidSwitchExternalPower = "lock";

      # After screen is locked, it waits until 20min of idle to 'suspend-then-hibernate'
      # combined with services.screen-locker in home-manager,
      # this will result in:  10m -> lock -> 10m -> suspend -> 30m -> hibernate
      extraConfig = "\n      IdleAction=suspend-then-hibernate\n      IdleActionSec=20min\n    ";
    };
  };

  # Power Management
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  # Bluetooth
  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket"; # Enable A2DP
        Name = "kasuari-default";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };

      Policy = {AutoEnable = "true";};
    };
  };

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # security.polkit.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    # alsa.enable = false;
    # alsa.support32Bit = false;
    pulse.enable = true;
  };

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
    packages = with pkgs; [firefox xorg.xf86videoamdgpu];

    shell = pkgs.zsh;
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    gparted
    exfatprogs

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
    killall

    # archive helper
    atool # easy zip unzip
    unzip
    zip
    libarchive
    p7zip

    nixos-option

    (catppuccin-sddm.override {
      flavor = "mocha";
      # background = config.environment.etc.wallpaper.source;
      # loginBackground = true;
    })

    # qtile
    xmobar
    # pipewire tui
    qpwgraph

    # bluetooth tui
    bluetuith
  ];

  fonts.packages = with pkgs; [wqy_zenhei wqy_microhei];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.git.enable = true;
  programs.bandwhich.enable = true;
  programs.git.config = {
    init = {defaultBranch = "main";};

    core = {editor = "nvim";};
  };

  programs.neovim = {
    enable = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [sensible vim-nix];
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {la = "ls -la";};

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
    plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
  };

  services.gnome.gnome-keyring.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # set default editor to neovim
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";

  # Allow user in `video` group to change brightness without sudo
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight" KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';

  # wait time to hibernate for 'suspend-then-hibernate' config
  systemd.sleep.extraConfig = "HibernateDelaySec=30min";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [3000 8000 8080 12345];
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
