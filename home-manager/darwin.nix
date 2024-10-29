{
  outputs,
  config,
  pkgs,
  ...
}: {
  imports = [./modules];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages
      outputs.overlays.darwin-packages
      outputs.overlays.nixos-2311-packages
    ];

    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "gu";
    homeDirectory = "/Users/gu";
  };

  home.sessionPath = ["${config.xdg.configHome}/emacs/bin"];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
  modules = {
    hostname = "osx";
    tmux.enable = true;
    neovim = {
      enable = true;
      lsp = true;
      completion = true;
    };
    fonts.dev = true;
    typeset.typst.enable = true;

    wezterm = {
      enable = true;
      configOnly = true;
    };

    git = {
      userName = "gumendol";
      userEmail = "gumelar@gpted.com";
      global-gitignore = [
        "_sandbox"
        ".secrets"
        ".vcr_library"
      ];
    };

    shell = {
      enable = true;
      proxyAddress = "http://localhost:7890";
    };

    nnn = {
      enable = true;
    };

    zettel = let
      zkDir = "${config.home.homeDirectory}/sync/zk";
    in {
      enable = true;
      nvimPluginEnable = true;
      defaultDir = "${zkDir}/inbox";
      notebookShellAliases = {
        zkw = "${zkDir}/work";
      };
    };

    dev-tools = {
      nix.enable = true;
      web = {
        enable = true;
        configOnly = true;
      };

      python = {
        enable = true;
        package = pkgs.nixos-2311.python38;
        pyenv = {
          enable = false;
          rootDirectory = "${config.home.homeDirectory}/.pyenv";
        };
      };
    };
  };

  home.packages = with pkgs; [
    taskwarrior
    exercism
    nb
    pipx
    ncurses
    rectangle

    ollama
  ];
}
