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
    programs.neovim = {
      enable = true;
      vimAlias = true;
      viAlias = true;
      extraConfig = builtins.readFile ./init.vim;
      extraLuaConfig = builtins.readFile ./config.lua;
      plugins = with pkgs.vimPlugins; [
        neovim-sensible
        dracula-nvim
        vim-surround
        vim-commentary
        emmet-vim
        typst-vim
        (nvim-treesitter.withPlugins (p: [
          p.nix
          p.go
          p.lua
          p.org
          p.python
          p.clojure
          p.markdown
          p.nim
          # prevent inlining
        ]))

        plenary-nvim
        telescope-nvim
        which-key-nvim
      ];
    };
  };
}
