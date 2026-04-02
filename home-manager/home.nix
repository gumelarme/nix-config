{
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./wayland.nix

    ./modules
    ./scripts
    ./common.nix
    ./modules/xdg
    ./modules/services

    ./modules/todo
    ./modules/nvim
    ./modules/tmux
    ./modules/rofi
    ./modules/shell
    ./modules/firefox
    ./modules/wezterm
    ./modules/hyprland
    ./modules/dev-tools
    ./modules/fonts.nix
    ./modules/typeset.nix
    ./modules/clipboard.nix
    ./modules/screenshot.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.nur-packages
      outputs.overlays.custom-packages
      (_self: _super: {fcitx-engines = pkgs.fcitx5;})
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
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "kasuari";
    homeDirectory = "/home/kasuari";
    pointerCursor = {
      package = pkgs.catppuccin-cursors.lattePeach;
      name = "catppuccin-latte-peach-cursors";
      size = 48;
      x11.enable = true;
      gtk.enable = true;
    };
  };

  gtk = {
    enable = true;
    gtk4.theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };

    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };
  };

  home.file."${config.xdg.configHome}" = {
    source = ./configs;
    recursive = true;
  };

  home.sessionPath = ["${config.xdg.configHome}/emacs/bin"];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-material-color
    ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  common = let
    my = config.xdg.userDirs.extraConfig;
  in {
    inherit (config.xdg) configHome;
    sync = my.SYNC;
    screenshot = my.SCREENSHOT;
  };

  modules = {
    hostname = "crockpot";
    rofi.enable = true;
    tmux.enable = true;
    screenshot.displayMode = "wayland";
    neovim = {
      enable = true;
      lsp = true;
      completion = true;
    };

    wezterm.enable = true;
    clipboard.enable = true;
    firefox.enable = true;

    git = {
      userName = "gumelarme";
      userEmail = "gumelar.pn@gmail.com";
    };

    fonts = {
      dev = true;
      extra = true;
    };

    nnn = {
      enable = true;
      bookmarks = let
        dirs = config.xdg.userDirs;
        extra = dirs.extraConfig;
      in {
        d = "${dirs.download}";
        v = "${extra.DEV}";
        r = "${extra.DEV}/repo";
        s = "${extra.SCREENSHOT}";
      };
    };

    shell = {
      enable = true;
      proxyAddress = "http://localhost:20171";
    };

    typeset = {
      latex.enable = true;
      typst.enable = true;
    };

    todo.enable = true;
    zettel = {
      enable = true;
      nvimPluginEnable = true;
    };

    dev-tools = {
      emacs.enable = false;
      python.enable = true;
      nix.enable = true;
      elm.enable = true;
      web.enable = true;
      go.enable = true;
      clojure.enable = true;
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      enkia.tokyo-night
      vadimcn.vscode-lldb
      # llvm-vs-code-extensions.lldb-dap
    ];
  };
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-vaapi
      obs-pipewire-audio-capture
    ];
  };

  programs.anki = {
    enable = true;
    addons = [
      pkgs.ankiAddons.anki-connect
    ];
  };

  home.packages = with pkgs; let
    entertainment = [
      vlc
      tauon
      nomacs
      netflix
      stable.blender
      mindustry-wayland
      netease-cloud-music-gtk
      waylyrics
      steam
      steam-run
      nicotine-plus
      (retroarch.withCores (
        cores:
          with cores; [
            beetle-gba
            beetle-psx-hw
          ]
      ))
    ];

    productivity = [
      ticktick
      tomato-c
      caffeine-ng
    ];

    gui-tools = [
      chromium
      krusader # dual pane file manager
      qutebrowser

      # AI
      jan
      ollama
      bitwarden-desktop
      qbittorrent
      pick-colour-picker
    ];

    virtualization = [
      docker
      distrobox
      xhost # allow distrobox to run gui program
      # stable.qemu
      # stable.quickemu
    ];

    system-tools = [
      trayer
      qrencode
      easyeffects # pipewire gui
      custom.tiny-bar
      custom.matcha
      kdePackages.ark # gui archive
    ];

    cli-tools = [
      jq
      dust # faster and prettier du
      mprocs # run multiple running programs
      imhex
      imagemagick
      ntfsprogs-plus # fix ntfs
    ];

    doc-utils = [
      pandoc
      zotero
      lorien
      stable.calibre
      libreoffice-qt

      # == pdf
      pdftk
      sioyek # pdf reader, research focused
      zathura
      pdfchain
    ];

    communication = [
      qq
      wechat-uos
      wemeet # official but still very unstable
      # nur.repos.linyinfeng.wemeet
      # nur.repos.novel2430.wemeet-bin-bwrap # CVE from a certain qtwebengine, chromium version
    ];

    peripheral = [
      usbutils
      # xsane
      sane-frontends
      simple-scan
      kdePackages.skanlite
      xf86videoamdgpu
      # libwacom
      # wacomtablet # KDE Config Module
    ];
  in
    builtins.concatLists [
      system-tools
      gui-tools
      cli-tools
      doc-utils
      communication
      productivity
      entertainment
      virtualization
      peripheral

      [
        exercism
        zlib
        gcc-unwrapped
      ]
    ];
}
