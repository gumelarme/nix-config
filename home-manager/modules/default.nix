{pkgs, ...}: {
  imports = [
    ./clipboard.nix
    ./fonts.nix
    ./typeset.nix

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
    fd
    ripgrep
    ripgrep-all # for pdfs, zip, docx etc.
    termdown
    tealdeer
    tree
    less
    glow
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
