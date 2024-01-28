{ pkgs, ... }:

{
  imports = [
    ./clipboard.nix
    ./fonts.nix

    ./services
    ./xdg

    ./eww
    ./nvim
    ./tmux
    ./rofi
    ./shell
    ./firefox
    ./wezterm
    ./dev-tools

  ];

  home.packages = with pkgs; [
    # System utils
    nurl
    rsync
    fdupes
    rclone

    # Secrets
    rbw
    bitwarden
    pinentry

    # Proxy
    qv2ray
  ];
}
