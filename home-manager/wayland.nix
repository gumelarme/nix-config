# === Wayland and hyprland related pacakges
{pkgs, ...}: {
  home.packages = with pkgs; [
    wofi

    ags
    eww

    swaylock

    # Screenshot tools
    grim
    slurp
    swappy

    # Backlight that wm independent
    brightnessctl
  ];
}
