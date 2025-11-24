{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hyprlock.nix
  ];

  services.hyprpolkitagent.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    settings = lib.mkMerge (
      lib.map
      (
        file:
          import file {
            inherit lib pkgs config;
          }
      )
      [
        ./keybind.nix
        ./decoration.nix
      ]
      ++ [
        {
          env = let
            cursor = config.home.pointerCursor;
            # remove suffix cursor from the name
            splitted = lib.splitString "-" cursor.name;
            hyprcursor_name = builtins.concatStringsSep "-" (
              lib.lists.take ((builtins.length splitted) - 1) splitted
            );
          in [
            "XCURSOR_THEME,${cursor.name}"
            "XCURSOR_SIZE,${toString cursor.size}"
            "HYPRCURSOR_THEME,${hyprcursor_name}"
            "HYPRCURSOR_SIZE,${toString cursor.size}"
          ];

          "debug:disable_logs" = false;
          monitor = [
            ", highres, 0x0, 1" # uncomment this for extend
            # ", preffered, auto, 1, mirror, eDP-1" # enable this for mirror
            "desc:ViewSonic Corporation VX2478-2 UYL211520009, 2560x1440, 0x0, 1"
            "eDP-1, 1920x1080, auto-right, 1"
          ];

          master = {
            new_status = "master";
            new_on_top = true;
          };

          exec-once = [
            "${pkgs.custom.tiny-bar}/bin/tiny-bar"
            "${pkgs.wpaperd}/bin/wpaperd -d "
            "${pkgs.custom.matcha}/bin/matcha --daemon --off"
          ];

          # plugins.hyprexpo = {
          #   columns = 3;
          #   gap_size = 5;
          #   bg_col = "rgb(111111)";
          #   workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1

          #   enable_gesture = true; # laptop touchpad
          #   gesture_fingers = 3; # 3 or 4
          #   gesture_distance = 300; # how far is the "max"
          #   gesture_positive = true; # positive = swipe down. Negative = swipe up.
          # };
        }
      ]
    );
  };
}
