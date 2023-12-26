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
    ./doom-emacs

  ];

  home.packages = with pkgs; [
    qv2ray
    chromium
    yesplaymusic

    # Dev
    nurl
    xclip

    # System utils
    feh
    rsync
    rclone
    arandr
    autorandr
    rofi-power-menu
    qrencode
    libsForQt5.ark # gui archive

    # Documents
    calibre
    zathura
    sioyek # pdf reader, research focused
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

    # mediainfo
    # glaxnimate

    # Misc
    steam
    steam-run
    discord
    tdesktop
    qutebrowser
    qq

    bitwarden
    rbw
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
