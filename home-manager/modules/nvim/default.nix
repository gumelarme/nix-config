{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.neovim;
in {
  options.modules.neovim.enable = mkEnableOption "Enable nvim configurations";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      marksman
    ];

    programs.nixneovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      # colorschemes.catppuccin.enable = true;
      extraConfigVim = builtins.readFile ./init.vim;
      extraConfigLua = builtins.readFile ./config.lua;

      extraPlugins =
        let extra = pkgs.vimExtraPlugins; 
        in 
        with pkgs.vimPlugins;
      [
        neovim-sensible
        dracula-nvim
        vim-surround
        vim-commentary
        emmet-vim
        typst-vim
        nvim-lspconfig
        plenary-nvim
        telescope-nvim
        which-key-nvim
        
        vim-markdown
        # pkgs.unstable.vimPlugins.markdown-nvim
        # extra.markdown-meandering-programmer 
      ];

      plugins.treesitter = {
        enable = true;
        grammars = with pkgs.vimPlugins.nvim-treesitter-parsers; [
          nix
          go
          lua
          org
          python
          clojure
          markdown
          markdown_inline
          nim
        ];
      };
    };
  };
}
