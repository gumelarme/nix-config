{pkgs, ...}:

{
  # ---- Programs configs
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
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./configs/.doom.d;
    extraPackages = with pkgs; [
      # tree-sitter
      emacsPackages.tree-sitter
    ];
  };

  programs.git = {
    enable = true;
    userName = "gumelarme";
    userEmail = "gumelar.pn@gmail.com";
    delta = {
      enable = true;
    };
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
    bookmarks = {};
    extraPackages = with pkgs; [ ffmpegthumbnailer mediainfo sxiv ];
    # TODO Add live previews and more plugins
    plugins = {
      mappings = {
          c = "fzcd";
          f = "finder";
          v = "imgview";
          z = "autojump";
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

  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
    theme = ./configs/rofi/theme/dracula-2.rasi; # path
    extraConfig = {
      modes = "drun,calc,emoji,run";
      display-calc = "=";
    };
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


  # z jump dir
  programs.zoxide = {
    enable = true;
  };

}
