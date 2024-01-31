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
    # System Utils
    git 
    fd
    tree
    less
    ripgrep
    ripgrep-all # for pdfs, zip, docx etc.
    coreutils
    wget
    curl

    ## Nix
    nurl
    nixos-option
    nix-prefetch-scripts

    ## Archive Helper
    atool
    zip
    unzip
    p7zip
    libarchive

    # File Management
    rsync
    rclone
    fdupes

    # Secrets
    rbw
    pinentry

    # Misc
    glow
    btop
    termdown
    tealdeer
  ];
}
