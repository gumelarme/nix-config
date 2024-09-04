{pkgs, ...}: {
  home.packages = with pkgs; [
    todo-txt-cli
    ttdl

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
    fpp # Facebook Path Picker

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
