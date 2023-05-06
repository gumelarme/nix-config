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
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

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

  home.packages = with pkgs; [
    # Fonts
    # TODO: Move to separate files
    ibm-plex
    dejavu_fonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif

    # Tools & CLI
    alacritty
    bat
    fd
    fzf
    ripgrep
    tldr
    tree

    # GUI
    bitwarden 
    emacs
    firefox
    gimp
    inkscape
    qbittorrent
    spotify
    jetbrains.pycharm-community
    # steam
  ];

  # ---- Programs configs
  # TODO: Set firefox userchrome

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

  programs.git = {
    enable = true;
    userName = "gumelarme";
    userEmail = "gumelar.pn@gmail.com";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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



  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
