{ pkgs, ... }:
{
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
