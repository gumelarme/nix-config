{
  inputs,
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # package = pkgs.unstable.hyprland;
    settings =
      lib.mkMerge
      (lib.map (file: import file {inherit lib pkgs;}) [./keybind.nix ./decoration.nix]
        ++ [
          {
            "debug:disable_logs" = false;
            monitor = [
              "DP-1, 1920x1080, 0x0, 1"
              "eDP-1, 1920x1080, 1920x0, 1"
            ];

            master = {
              new_status = "master";
            };
          }
        ]);
  };
}
