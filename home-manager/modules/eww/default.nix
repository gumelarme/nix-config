{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.eww;
in {
  options.modules.eww.enable = mkEnableOption "Enable eww configurations";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [mpc-cli ffmpeg];
    programs.eww = {
      enable = true;
      configDir = ./.;
    };
  };
}
