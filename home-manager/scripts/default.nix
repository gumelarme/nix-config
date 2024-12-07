{pkgs, ...}: let
  prefix = "crock";
in {
  home.packages = [
    (import ./snap.nix {inherit prefix pkgs;})
    (import ./summon.nix {inherit prefix pkgs;})
    (import ./change-brightness.nix {inherit prefix pkgs;})
    (import ./change-volume.nix {inherit prefix pkgs;})
    (import ./mic-toggle.nix {inherit prefix pkgs;})
    (import ./gen-qr.nix {
      inherit prefix pkgs;
      source = "${pkgs.wl-clipboard}/bin/wl-paste";
    })
  ];
}
