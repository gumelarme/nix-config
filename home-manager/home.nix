{
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [./modules ./modules/xdg ./modules/services ./wayland.nix ./modules/hyprland ./modules/todo ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.nur-packages
      (self: super: {fcitx-engines = pkgs.fcitx5;})

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
    # pointerCursor = {
    #   package = pkgs.catppuccin-cursors.lattePeach;
    #   name = "Catppuccin-Latte-Peach-Cursors";
    #   size = 32;
    #   x11.enable = true;
    #   gtk.enable = true;
    # };
  };

  gtk = {
    enable = true;
    theme = {
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
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-rime fcitx5-material-color];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  modules = {
    hostname = "crockpot";
    rofi.enable = true;
    tmux.enable = true;
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
        v = "${extra.XDG_DEV_DIR}";
        r = "${extra.XDG_DEV_DIR}/repo";
        s = "${extra.XDG_SCREENSHOT_DIR}";
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

    zettel = {
      enable = true;
      nvimPluginEnable = true;
      defaultDir = "${config.xdg.userDirs.extraConfig.XDG_SYNC_DIR}/zk/inbox";
    };

    dev-tools = {
      emacs.enable = true;
      python.enable = true;
      nix.enable = true;
      elm.enable = true;
      web.enable = true;
      go.enable = true;
      clojure.enable = true;
    };
  };

  home.packages = with pkgs;
    [
      chromium
      nb
      # pomodoro
      tomato-c

      caffeine-ng

      # =Dev
      distrobox
      xorg.xhost # allow distrobox to run gui program

      exercism
      jetbrains.pycharm-professional
      jetbrains.datagrip
      jetbrains.webstorm
      jetbrains.goland
      jetbrains.rider
      docker
      # needed for building driver and access to postgres clis and lib
      postgresql_12_jit

      # System utils
      trayer
      dmenu
      arandr
      autorandr
      qrencode
      easyeffects # pipewire gui
      # clang
      gcc-unwrapped
      zlib
      libsForQt5.ark # gui archive
      rofi-power-menu

      # Browser
      brave
      qutebrowser

      # Etc
      v2ray
      qv2ray
      bitwarden
      qbittorrent
      pick-colour-picker
      nicotine-plus
      # fontforge;

      # Documents
      pandoc
      zotero
      stable.calibre
      zathura
      sioyek # pdf reader, research focused
      xournalpp
      lorien
      libreoffice-qt
      pdftk
      pdfchain

      # Media
      feh
      imagemagick
      vlc
      tauon
      spotify
      nomacs
      yesplaymusic
      # mediainfo
      # gimp  # annoyingly replaces xdg-mime for image/*
      # blender
      # godot
      # inkscape
      # glaxnimate

      # Games
      steam
      steam-run

      # Communication
      qq
      stable.discord
      tdesktop

      # Peripheral
      xsane
      sane-frontends
      simple-scan
      libsForQt5.skanlite
      xboxdrv
      # libwacom
      # wacomtablet # KDE Config Module
      xorg.xf86videoamdgpu
      xorg.xf86videointel
      usbutils

      nur.repos.linyinfeng.wemeet
    ]
    ++ (
      let
        # Add scripts to bin from file
        fileToScripts = file:
          pkgs.writeShellScriptBin (builtins.baseNameOf file)
          (builtins.readFile file);
        getFilesFromDir = dir: files: map (f: dir + "/${f}") files;
      in
        map
        fileToScripts
        (getFilesFromDir ./scripts ["summon" "crock" "crock-change-volume" "crock-change-brightness" "crock-gen-qrcode" "crock-mic-toggle" "crock-rofi-power-menu"])
    );

  # home.sessionVariables = {
  #   LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ stdenv.cc.cc zlib ];
  # };
}
