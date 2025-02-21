# === Wayland and hyprland related pacakges
{pkgs, ...}: {
  home.packages = with pkgs; [
    swaylock
    wl-clipboard

    # Backlight that wm independent
    brightnessctl
  ];
}
