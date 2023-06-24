{ pkgs, config, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      g = "git";
      s = "git status";
      mucik = "ncmpcpp";
    };

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
    "
    + (builtins.readFile ./configs/zsh-scripts/nnn-config)
    + (builtins.readFile ./configs/zsh-scripts/nnn-quitcd);
  };

  programs.git = {
    enable = true;
    userName = "gumelarme";
    userEmail = "gumelar.pn@gmail.com";
    delta = {
      enable = true;
      options = {
        decorations = {
          syntax-theme = "Dracula";
        };
        features = "decorations";
        line-numbers = true;
      };
    };
    aliases = {
      d = "diff";
      ds = "diff --staged";
      l = "log";
      lo = "log --graph --oneline";
      ls = "log --graph --name-status";
    };
  };

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override({ withNerdIcons = true; });
    extraPackages = with pkgs; [ glow libnotify mediainfo viu ];
    bookmarks =
      let
        userDirs = config.xdg.userDirs;
      in
        {
          d = "${userDirs.download}";
          v = "${userDirs.extraConfig.XDG_DEV_DIR}";
          r = "${userDirs.extraConfig.XDG_DEV_DIR}/repo";
          s = "${userDirs.extraConfig.XDG_SCREENSHOT_DIR}";
        };

    plugins = {
      mappings = {
          f = "fzcd";
          v = ".ntfy";
          m = "nmount";
          p = "preview-tui";
          r = "gitroot";
      };

      src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.8";
          sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
      }) + "/plugins";
    };
  };

  programs.mcfly = {
    enable = true;
    keyScheme = "vim";
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # use mcfly instead
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman prettybat ];
    config = {
      theme = "Dracula";
    };
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
}
