# === Wayland and hyprland related packages
{
  lib,
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    swaylock
    wl-clipboard

    # Backlight that wm independent
    brightnessctl
  ];

  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "3h";
        mode = "center";
        path = "${config.xdg.userDirs.pictures}/wallpapers";

        transition.glitch-memories = {};
      };
    };
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.swaylock = {
    enable = true;
    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;
      show-keyboard-input = true;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;

      # Cosmetics
      image = "${pkgs.kasuari-wallpapers}/img/kumamon.png";
      indicator-radius = 150;
      indicator-thickness = 30;
      indicator-idle-visible = false;
      separator-color = "#ffffff";
      key-hl-color = "#ff0000";
      ring-color = "#444444";
      inside-color = "#111111";
    };
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 5 * 60;
        command = "${lib.getExe pkgs.swaylock} --daemonize";
      }

      {
        timeout = 30 * 60;
        command = "systemctl suspend";
      }
    ];

    # Suppresses error
    # https://github.com/swaywm/swayidle/issues/198
    events = {
      before-sleep = "true";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk #fallback
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gnome # for screen casting support
      # oo7-portal
    ];

    config.common = {
      default = ["gtk"];
    };

    # https://github.com/niri-wm/niri/wiki/Important-Software
    # https://github.com/niri-wm/niri/wiki/Getting-Started#manual-installation
    config.niri = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];

      # hopefully stop crashing from electrons app trying to inhibit idle (logseq)
      "org.freedesktop.impl.portal.Inhibit" = ["none"];
    };
  };
}
