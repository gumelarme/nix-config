{ pkgs, ... }:
{
  imports = [
    ./services
    ./xdg

    ./nvim
    ./tmux
    ./wezterm
    ./rofi
    ./shell
    ./doom-emacs

    ./fonts.nix
    ./packages.nix
  ];

  # TODO: Configure user chrome
  programs.firefox.enable = true;
}
