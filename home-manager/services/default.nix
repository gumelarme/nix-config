{pkgs, config, ... }:

{
  imports = [
    ./battery.nix
    ./dunst.nix
  ];

  services.network-manager-applet.enable = true;

  services.picom = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = ["--gui-address=:12300"];
    # tray.enable = true;
  };

  services.screen-locker = {
    enable = true;
    # This lock the screen with cached image
    # it needs to be prepared before hand otherwise it will show black background
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l";
    inactiveInterval = 10;
    xautolock = {
      enable = true;
      detectSleep = true; # reset timer after sleep
    };
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        savePath = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOT_DIR}";
        saveAsFileExtension="png";
        copyPathAfterSave = true;
      };
    };
  };
}
