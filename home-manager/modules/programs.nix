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
}
