# === Wayland and hyprland related pacakges
{pkgs, ...}: {
  home.packages = with pkgs; [
    wofi

    ags
    eww

    swaylock
    wl-clipboard

    # Screenshot tools
    grim
    slurp
    swappy

    # Backlight that wm independent
    brightnessctl
  ];
}
