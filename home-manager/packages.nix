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
    bat
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
    syncthing
    termdown
    tealdeer
    texlive.combined.scheme-full
    tree
    xclip
    xplr
    betterlockscreen


    # GUI
    calibre
    bitwarden
    blender
    discord
    flameshot
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
}
