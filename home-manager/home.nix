{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [ ./modules ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      (self: super: { fcitx-engines = pkgs.fcitx5; })

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

  home.sessionPath = [ "${config.xdg.configHome}/emacs/bin" ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";

  modules = {
    wezterm.enable = true;

    fonts = {
      dev = true;
      latex = true;
      ms-core = true;
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
  };

}
