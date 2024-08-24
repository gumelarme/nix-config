{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.modules.neovim;
in {
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        quick-scope
      ];

      extraConfigVim = ''
        let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

        highlight QuickScopePrimary gui=underline cterm=underline
        highlight QuickScopeSecondary gui=underline cterm=underline
      '';
    };
  };
}
