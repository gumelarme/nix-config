# === Wayland and hyprland related pacakges
{
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
}
