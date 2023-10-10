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
    clash-verge
    nurl
    xclip
    docker
    postman
    python3Full
    nodePackages.pnpm
    jetbrains.pycharm-community
    jetbrains.datagrip
    jetbrains.webstorm

    # System utils
    feh
    rsync
    rclone
    arandr
    autorandr
    rofi-power-menu
    bottles # wine manager
    # gparted

    # Documents
    simplenote
    calibre
    zathura
    xournalpp
    lorien
    libreoffice-qt
    kuro

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
    qq

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
