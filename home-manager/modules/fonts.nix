{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ibm-plex
    dejavu_fonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-code-pro
    symbola
    wqy_zenhei
    wqy_microhei
    (nerdfonts.override { fonts = [ "IBMPlexMono" "DejaVuSansMono" ]; })
  ];
}
