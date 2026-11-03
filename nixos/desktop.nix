{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    niri
    swaylock
    fuzzel
    xwayland-satellite # TODO: review
    networkmanagerapplet # NetworkManager control applet for GNOME
  ];

  # As a backup, incase Niri is not working
  programs.sway.enable = true;
  programs.niri.enable = true;
  security.pam.services.swaylock.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time -g Ahoy! --remember --remember-session";
        user = "greeter";
      };
    };
  };

  services.xserver = {
    enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    # run XDGAutostart even if there is no DE
    desktopManager.runXdgAutostartIfNone = true;
    desktopManager.xfce = {
      enable = true;
      enableScreensaver = false;
    };
  };

  services.logind.settings.Login = {
    # See options at: man logind.conf
    HandlePowerKey = "hybrid-sleep";
    HandlePowerKeyLongPress = "poweroff";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate"; # lid closed but another screen is connected
    HandleLidSwitchExternalPower = "lock";

    # After screen is locked, it waits until 20min of idle to 'suspend-then-hibernate'
    # combined with services.screen-locker in home-manager,
    # this will result in:  10m -> lock -> 10m -> suspend -> 30m -> hibernate
    IdleAction = "suspend-then-hibernate";
    IdleActionSec = "1200";
  };

  # wait time to hibernate for 'suspend-then-hibernate' config
  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30min";
  };
}
