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

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./configs/wezterm.lua;
  };

  # emacs specific packages
  home.packages = with pkgs; [
    sqlite
    gopls
    poetry
    nodePackages.pyright

    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];

  programs.doom-emacs = {
    enable = true;
    package = pkgs.emacs29.override({
      withPgtk = true;
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });

    doomPrivateDir = ./configs/.doom.d;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    extraConfig = builtins.readFile ./configs/nvim/init.vim;
    extraLuaConfig = builtins.readFile ./configs/nvim/config.lua;
    plugins = with pkgs.vimPlugins; [
      neovim-sensible
      dracula-nvim
      vim-surround
      vim-commentary
      emmet-vim
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.go
        p.org
        p.python
        p.clojure
        p.markdown
      ]))

      plenary-nvim
      telescope-nvim
    ];
  };
}
