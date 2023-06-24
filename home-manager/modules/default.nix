{ pkgs, ... }:
{
  imports = [
    ./default-apps.nix
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./xdg.nix

    ./lowbatt-notification.nix
    ./dunst.nix
    ./mopidy.nix
  ];
}
