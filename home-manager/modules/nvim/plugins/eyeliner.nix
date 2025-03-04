{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.eyeliner-nvim
    ];

    extraConfigLua = ''
      require("eyeliner").setup {
        highlight_on_key = true,
        dim = true,
      }
    '';
  };
}
