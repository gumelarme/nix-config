{
  inputs,
  pkgs,
  lib,
  config,
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
      (lib.map (file: import file {inherit lib pkgs config;}) [./keybind.nix ./decoration.nix]
        ++ [
          {
            env = let
              cursor = config.home.pointerCursor;
              # remove suffix cursor from the name
              splitted = lib.splitString "-" cursor.name;
              hyprcursor_name = builtins.concatStringsSep "-" (lib.lists.take ((builtins.length splitted) - 1) splitted);
            in [
              "XCURSOR_THEME,${cursor.name}"
              "XCURSOR_SIZE,${toString cursor.size}"
              "HYPRCURSOR_THEME,${hyprcursor_name}"
              "HYPRCURSOR_SIZE,${toString cursor.size}"
            ];

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
