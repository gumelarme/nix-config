{ pkgs, ... }:
{
  imports = [
    ./services
    ./xdg

    ./nvim
    ./tmux
    ./rofi
    ./shell
    ./firefox
    ./wezterm
    ./doom-emacs

    ./fonts.nix
    ./packages.nix
  ];
}
