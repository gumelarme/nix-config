{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.fonts;
in {
  options.modules.fonts = {
    dev = mkEnableOption "Enable dev fonts";
    extra = mkEnableOption "Enable UI and CJK Fonts";
  };
  config = {
    home.packages = with pkgs;
      mkMerge [
        (mkIf cfg.dev [
          dejavu_fonts # required hyprland -> pango
          maple-mono.NF-CN
        ])

        (mkIf cfg.extra [
          # Latex math fonts to be used in libreoffice
          lmmath
          newcomputermodern

          # cjk
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          atkinson-hyperlegible
        ])
      ];
  };
}
