# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    inputs.nix-doom-emacs.hmModule
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      (self: super: {
        fcitx-engines = pkgs.fcitx5;
      })

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "kasuari";
    homeDirectory = "/home/kasuari";
  };

  home.file."${config.xdg.configHome}" = {
    source = ./home/.config;
    recursive = true;
  };

  home.packages = with pkgs; [
    # Fonts
    # TODO: Move to separate files
    ibm-plex
    dejavu_fonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-code-pro
    symbola
    # emacs-all-the-icons-fonts
    wqy_zenhei
    wqy_microhei
    (nerdfonts.override { fonts = ["IBMPlexMono" "DejaVuSansMono"]; } )

    # Tools & CLI
    alacritty
    bat
    clang
    docker
    fd
    fzf
    imagemagick
    pandoc
    python3Full
    ranger
    rclone
    ripgrep
    rsync
    syncthing
    termdown
    tealdeer
    texlive.combined.scheme-full
    tree
    xclip
    yt-dlp

    # Peripheral
    xsane
    xboxdrv
    libwacom
    # xf86_input_wacom
    wacomtablet # KDE Config Module

    # GUI
    calibre
    bitwarden
    blender
    discord
    gimp
    godot
    gparted
    inkscape
    jetbrains.pycharm-community
    lorien
    postman
    qbittorrent
    steam
    steam-run
    spotify
    tdesktop
    vlc
    xournalpp
    zathura

    # KDE related
    libsForQt5.ark
    libsForQt5.dolphin-plugins


    # Libreoffice
    libreoffice-qt
    hunspell
    hunspellDicts.en_US

    # music player
    blanket # white noise player
    tauon
    nicotine-plus

    # file explorer
    mc
    xplr
  ];

  # ---- Programs configs
  # TODO: Set firefox userchrome
  programs.firefox = {
    enable = true;
  };


  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.9;
        dynamic_title = true;
        padding.x = 5;
        padding.y = 7;
      };

      font = {
        normal = {
          family = "DejaVuSansMono";
          style = "Regular";
        };
        size = 7;
      };
    };
  };

  # Doom emacs
  # TODO: Fix fonts and icons
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./home/.doom.d;
    extraPackages = with pkgs; [
      tree-sitter
    ];
  };

  programs.git = {
    enable = true;
    userName = "gumelarme";
    userEmail = "gumelar.pn@gmail.com";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # use mcfly instead
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      neovim-sensible
      vim-nix
      vim-surround
      commentary
      # TODO: add more
    ];
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      extrakto
      tmux-colors-solarized
      # NOTE: want dracula, but very slow
    ];
  };

  programs.nnn = {
    enable = true;
    bookmarks = {};
    extraPackages = with pkgs; [ ffmpegthumbnailer mediainfo sxiv ];
    plugins = {};
  };

  programs.mcfly = {
    enable = true;
    keyScheme = "vim";
  };

  programs.rofi = {
    enable = true;
    plugins = [];
    font = "Hack 14";
    theme = null; # path
    extraConfig = {};
  };

  programs.zsh = {
    enable = true;
    # enableSyntaxHighlighting = true; # breaks edit-command-line bindings
    prezto = {
      enable = true;
      editor.keymap = "vi";
      prompt = {
        theme = "steeef";
        pwdLength = "long";
      };
    };

    initExtra = "
      bindkey -M vicmd '^v' edit-command-line
    ";
  };


  programs.zoxide = {
    enable = true;
  };

  services.dunst = {
    enable = true;
    configFile = ./home/.config/dunst/dunstrc;
  };

  services.picom = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = ["--gui-address=:12300"];
    # tray.enable = true;
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
