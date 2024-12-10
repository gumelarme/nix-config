{pkgs, ...}: {
  programs.nixvim.extraPlugins = with pkgs.vimPlugins; [
    (with pkgs.vimUtils;
      buildVimPlugin {
        pname = "smear-cursor.nvim";
        version = "2024-02-07";
        src = pkgs.fetchFromGitHub {
          owner = "sphamba";
          repo = "smear-cursor.nvim";
          rev = "ff52effc1da115f97925939b986e7e686a1cb78a";
          sha256 = "sha256-ODcBKBsZVfsrS1Qyt72KD3aI381//+EMjEMgCTCnoU4";
        };
      })
  ];

  programs.nixvim.extraConfigLua = ''
    require("smear_cursor").setup({
      stiffness = 0.5,               -- 0.6      [0, 1]
      trailing_stiffness = 0.5,      -- 0.3      [0, 1]
      distance_stop_animating = 0.5, -- 0.1      > 0
      hide_target_hack = false,      -- true     boolean
      legacy_computing_symbols_support = true,
      transparent_bg_fallback_color = "#303030",
    })
  '';
}
