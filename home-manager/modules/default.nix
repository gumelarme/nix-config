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
    ./doom-emacs

  ];

  home.packages = with pkgs; [
    # Dev
    nurl
    xclip
    docker
    postman
    python3Full
    jetbrains.pycharm-community

    # System utils
    feh
    rsync
    rclone
    arandr
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
    # libwacom
    # wacomtablet # KDE Config Module
  ];
}
