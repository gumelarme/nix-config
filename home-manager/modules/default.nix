{ pkgs, ... }:

{
  imports = [
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
    feh
    nurl
    xclip
    rsync
    fdupes
    rclone
    arandr
    autorandr
    rofi-power-menu
    qrencode
    libsForQt5.ark # gui archive
    qv2ray

    # Documents
    calibre
    zathura
    sioyek # pdf reader, research focused
    xournalpp
    lorien
    libreoffice-qt
    pdftk
    pdfchain

    # Media
    vlc
    tauon
    spotify
    nomacs
    nicotine-plus
    yesplaymusic
    # mediainfo
    # gimp  # annoyingly replaces xdg-mime for image/*
    # blender
    # godot
    # inkscape
    # glaxnimate

    # Games
    steam
    steam-run

    # Communication
    qq
    discord
    tdesktop

    qutebrowser
    chromium
    qbittorrent

    # Secrets
    rbw
    bitwarden
    pinentry

    # Peripheral
    xsane
    sane-frontends
    gnome.simple-scan
    libsForQt5.skanlite
    xboxdrv
    # libwacom
    # wacomtablet # KDE Config Module
    xorg.xf86videoamdgpu
    xorg.xf86videointel
  ];
}
