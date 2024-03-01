{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.go;
in {
  options.modules.dev-tools.go = {
    enable = mkEnableOption "Enable go development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gcc
      go
      godef
      gopls
      gomodifytags
      gotests
      gotools
    ];
  };
}
