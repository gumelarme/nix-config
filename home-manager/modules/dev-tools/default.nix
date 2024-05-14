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
    ./web.nix
    ./go.nix
    ./clojure.nix
    ./intellimacs.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    cachix
    gnumake
    httpie
    hurl
    shellcheck
    shfmt
  ];
}
