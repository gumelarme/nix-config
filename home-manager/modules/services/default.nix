{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./dunst.nix
    ./lowbatt-notification.nix
    ./mopidy.nix
    ./ding_dong.nix
  ];

  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;

  services.syncthing = {
    enable = true;
    tray.enable = true;
    extraOptions = [
      "--gui-address=:12300"
    ];
  };

  # === X11 Specifics configs
  services.picom = {
    enable = false;
  };

  home.packages = [pkgs.betterlockscreen];
  services.xidlehook = {
    enable = false;
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
    enable = false;
    settings = {
      General = {
        savePath = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}";
        saveAsFileExtension = "png";
        copyPathAfterSave = true;
      };
    };
  };
}
