{pkgs, ...}: {
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
    statix # linter
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
    (
      if pkgs.stdenv.isDarwin
      then pinentry_mac
      else pinentry
    )

    # Misc
    glow
    btop
    termdown
    tealdeer
  ];
}
