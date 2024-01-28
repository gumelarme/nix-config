{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.rofi;
in {
  options.modules.rofi = {enable = mkEnableOption "Enable rofi";};
  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [rofi-calc rofi-emoji];
      theme = ./theme/dracula-2.rasi; # path
      extraConfig = {
        modes = "drun,calc,emoji,run";
        display-calc = "=";
      };
    };
  };
}
