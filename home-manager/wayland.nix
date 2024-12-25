# === Wayland and hyprland related pacakges
{pkgs, ...}: {
  home.packages = with pkgs; [
    ags
    eww

    swaylock
    wl-clipboard

    # Backlight that wm independent
    brightnessctl
  ];
}
