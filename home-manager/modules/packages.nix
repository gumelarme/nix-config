{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Fonts
    ibm-plex
    dejavu_fonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-code-pro
    symbola
    wqy_zenhei
    wqy_microhei
    (nerdfonts.override { fonts = ["IBMPlexMono" "DejaVuSansMono"]; } )

    # Tools & CLI
    autorandr
    clang
    docker
    fd
    imagemagick
    libcanberra-gtk3 # used with dunst to play notification sound
    pandoc
    python3Full
    ranger
    rclone
    ripgrep
    rsync
    termdown
    tealdeer
    texlive.combined.scheme-full
    tree
    xclip
    xplr
    betterlockscreen
    less
    glow

    # GUI
    calibre
    bitwarden
    blender
    discord
    # gimp  # annoyingly replaces xdg-mime for image/*
    godot
    gparted
    inkscape
    jetbrains.pycharm-community
    lorien
    nicotine-plus
    nomacs
    postman
    qbittorrent
    rofi-power-menu
    steam
    steam-run
    spotify
    tauon
    tdesktop
    vlc
    xournalpp
    zathura
    qutebrowser

    # KDE related
    libsForQt5.ark
    libsForQt5.dolphin-plugins

    # Libreoffice
    libreoffice-qt
    hunspell
    hunspellDicts.en_US

    # Peripheral
    xsane
    xboxdrv
    libwacom
    wacomtablet # KDE Config Module
  ];
  # Add scripts to bin from file
  # ++ (let
  #       fileToScripts = file: pkgs.writeShellScriptBin (builtins.baseNameOf file) (builtins.readFile file);
  #       getFilesFromDir = dir: files: map (f: dir + "/${f}") files;
  #   in map fileToScripts (getFilesFromDir ./bin [
  #       # "nn"
  #   ])
  # )
  # ;

}
