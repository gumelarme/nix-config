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
              ", highres, 0x0, 1"
              "eDP-1, 1920x1080, auto-right, 1"
            ];

            master = {
              new_status = "master";
              new_on_top = true;
            };

            exec-once = [
              "ags"
              "${pkgs.wpaperd}/bin/wpaperd -d "
            ];
          }
        ]);
  };
}
