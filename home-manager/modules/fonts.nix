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
          monaspace
          ibm-plex
          dejavu_fonts
          source-code-pro
          (nerdfonts.override {fonts = ["IBMPlexMono" "DejaVuSansMono" "Monaspace"];})
        ])

        (mkIf cfg.extra [
          noto-fonts
          noto-fonts-extra
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          atkinson-hyperlegible
        ])
      ];
  };
}
