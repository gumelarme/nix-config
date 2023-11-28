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
    qv2ray
    chromium
    yesplaymusic

    # Dev
    clash-verge
    nurl
    xclip
    docker
    postman
    python3Full
    postgresql_12_jit
    nodejs_20
    nodePackages.pnpm
    # jetbrains.pycharm-community
    jetbrains.pycharm-professional
    jetbrains.datagrip
    jetbrains.webstorm
    # qemu
    # qemu_kvm
    # virt-manager

    # System utils
    feh
    rsync
    rclone
    arandr
    autorandr
    rofi-power-menu
    qrencode
    libsForQt5.ark # gui archive
    # gparted

    # Documents
    simplenote
    calibre
    zathura
    sioyek # pdf reader, research focused
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
