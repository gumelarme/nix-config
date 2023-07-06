{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # Dev
    xclip
    docker
    postman
    python3Full
    jetbrains.pycharm-community

    # System utils
    rsync
    rclone
    autorandr
    rofi-power-menu
    # gparted

    # Documents
    calibre
    zathura
    xournalpp
    lorien
    libreoffice-qt

    # Media
    vlc
    tauon
    spotify
    nomacs
    # blender
    # godot
    # inkscape
    qbittorrent
    nicotine-plus
    # gimp  # annoyingly replaces xdg-mime for image/*

    ## Kdenlive
    # mediainfo
    # glaxnimate
    # libsForQt5.kdenlive

    # Misc
    steam
    steam-run
    discord
    tdesktop
    bitwarden
    qutebrowser

    # Peripheral
    xsane
    xboxdrv
    libwacom
    wacomtablet # KDE Config Module
  ];
}
