{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.elm;
in {
  options.modules.dev-tools.elm = {
    enable = mkEnableOption "Enable elm development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      elmPackages.elm
      elmPackages.elm-format
      elmPackages.elm-language-server
    ];
  };
}
