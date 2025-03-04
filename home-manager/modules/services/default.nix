{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dunst.nix
    ./lowbatt-notification.nix
    ./mopidy.nix
    ./greenclip.nix
    ./ding_dong.nix
    # Prevent
  ];

  services.network-manager-applet.enable = true;

  services.picom = {enable = true;};
  services.blueman-applet.enable = true;

  services.syncthing = {
    enable = true;
    extraOptions = ["--gui-address=:12300" "--no-default-folder"];
    # tray.enable = true;
  };

  home.packages = [pkgs.betterlockscreen];

  services.xidlehook = {
    enable = true;
    detect-sleep = true; # reset timer after sleep
    not-when-fullscreen = true;
    timers = [
      # the delay time stacks one after another.
      # decrease backlight doesnt work for some reason
      # {
      #   delay = 30;
      #   command = "${pkgs.acpilight}/bin/xbacklight -display eDP-1 -dec 5 > /home/kasuari/acpilog";
      #   canceller = "${pkgs.acpilight}/bin/xbacklight -display eDP-1 -inc 5 > /home/kasuari/acpilog";
      # }
      {
        delay = 600;
        command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
      }
    ];
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}";
        saveAsFileExtension = "png";
        copyPathAfterSave = true;
      };
    };
  };

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "3h";
        mode = "center";
        path = "${config.xdg.userDirs.pictures}/wallpapers";
      };
    };
  };
}
