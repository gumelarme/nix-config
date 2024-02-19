{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools;
in {
  imports = [
    ./elm.nix
    ./emacs.nix
    ./nix.nix
    ./python.nix
    # ./web.nix
  ];

  home.packages = with pkgs; [
    gnumake
    httpie
    hurl
  ];
}
