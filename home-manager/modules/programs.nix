{pkgs, config, ...}:

{
  # TODO: Configure user chrome
  programs.firefox.enable = true;

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
    theme = ./configs/rofi/theme/dracula-2.rasi; # path
    extraConfig = {
      modes = "drun,calc,emoji,run";
      display-calc = "=";
    };
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

  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./configs/.doom.d;
    extraPackages = with pkgs; [
      emacsPackages.tree-sitter
    ];
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [ batman prettybat ];
    config = {
      theme = "Dracula";
    };
  };


  programs.fzf = {
    enable = true;
    enableZshIntegration = false; # use mcfly instead
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

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      neovim-sensible
      vim-nix
      vim-surround
      commentary
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
}
