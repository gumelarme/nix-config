{ pkgs, config, lib, ... }:
with lib;
let cfg = config.modules.fonts;
in {
  options.modules.fonts = {
    dev = mkEnableOption "Enable dev fonts";
    latex = mkEnableOption "Enable latex related fonts";
    ms-core = mkEnableOption "Enable ms corefonts";
    extra = mkEnableOption "Enable UI and CJK Fonts";
  };
  config = {
    home.packages = with pkgs;
      mkMerge [
        (mkIf cfg.dev [
          ibm-plex
          dejavu_fonts
          source-code-pro
          (nerdfonts.override { fonts = [ "IBMPlexMono" "DejaVuSansMono" ]; })
        ])

        (mkIf cfg.latex [ symbola wqy_zenhei wqy_microhei ])

        (mkIf cfg.ms-core [ corefonts ])

        (mkIf cfg.extra [
          noto-fonts
          noto-fonts-extra
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ])
      ];
  };
}
