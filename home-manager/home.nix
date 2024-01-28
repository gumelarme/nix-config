{
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [./modules ./modules/xdg ./modules/services];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
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
    pointerCursor = {
      package = pkgs.catppuccin-cursors.lattePeach;
      name = "Catppuccin-Latte-Peach-Cursors";
      size = 32;
      x11.enable = true;
      gtk.enable = true;
    };
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
    fcitx5.addons = with pkgs; [fcitx5-rime];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  modules = {
    rofi.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    wezterm.enable = true;
    clipboard.enable = true;

    fonts = {
      dev = true;
      extra = true;
    };

    nnn = {
      enable = true;
      bookmarks = let
        userDirs = config.xdg.userDirs;
        extra = userDirs.extraConfig;
      in {
        d = "${userDirs.download}";
        v = "${extra.XDG_DEV_DIR}";
        r = "${extra.XDG_DEV_DIR}/repo";
        s = "${extra.XDG_SCREENSHOT_DIR}";
      };
    };

    shell = {
      enable = true;
      proxyAddress = "http://localhost:20170";
    };

    typeset = {
      latex.enable = true;
      typst.enable = true;
    };

    dev-tools = {
      python.enable = true;
      nix.enable = true;
      elm.enable = true;
      web.enable = true;
    };
  };

  home.packages = with pkgs;
    [
      # =Dev
      jetbrains.pycharm-professional
      jetbrains.datagrip
      jetbrains.webstorm
      docker
      # needed for building driver and access to postgres clis and lib
      postgresql_12_jit

      # System utils
      arandr
      autorandr
      qrencode
      # clang
      gcc-unwrapped
      zlib
      libsForQt5.ark # gui archive
      rofi-power-menu

      # Browser
      brave
      qutebrowser

      # Etc
      qbittorrent
      pick-colour-picker
      nicotine-plus
      # fontforge;

      # Documents
      pandoc
      zotero
      calibre
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
      discord
      tdesktop

      # Peripheral
      xsane
      sane-frontends
      gnome.simple-scan
      libsForQt5.skanlite
      xboxdrv
      # libwacom
      # wacomtablet # KDE Config Module
      xorg.xf86videoamdgpu
      xorg.xf86videointel
    ]
    ++ (let
      # Add scripts to bin from file
      fileToScripts = file:
        pkgs.writeShellScriptBin (builtins.baseNameOf file)
        (builtins.readFile file);
      getFilesFromDir = dir: files: map (f: dir + "/${f}") files;
    in
      map fileToScripts
      (getFilesFromDir ./modules/shell/scripts ["mywacom"]));

  # home.sessionVariables = {
  #   LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ stdenv.cc.cc zlib ];
  # };
}
