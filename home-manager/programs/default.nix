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
      tree-sitter
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


  # z jump dir
  programs.zoxide = {
    enable = true;
  };

}
