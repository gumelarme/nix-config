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
    configType = "lua";
    settings = lib.mkMerge [
      (import ./config.nix {})
      (import ./monitor.nix {})
      (import ./rules.nix {})
      (import ./animation.nix {})
      (import ./smart-gaps.nix {})
      (import ./keybind.nix {inherit lib pkgs config;})
      {
        env = let
          env = key: val: {_args = [key val];};
          cursor = config.home.pointerCursor;
          split = lib.splitString "-" cursor.name;
          hyprcursor_name = builtins.concatStringsSep "-" (
            lib.lists.take ((builtins.length split) - 1) split
          );
        in [
          (env "XCURSOR_THEME" cursor.name)
          (env "XCURSOR_SIZE" (toString cursor.size))
          (env "HYPRCURSOR_THEME" hyprcursor_name)
          (env "HYPRCURSOR_SIZE" (toString cursor.size))
        ];

        on = let
          lua = lib.generators.mkLuaInline;
          e = bin: "\t hl.exec_cmd(\"${bin}\")";
          on_ = event: programs: {
            _args = [
              event
              (lua (
                lib.strings.concatStringsSep "\n" (["function()"] ++ programs ++ ["end"])
              ))
            ];
          };
        in
          on_ "hyprland.start" [
            (e "anki")
            (e "${pkgs.custom.tiny-bar}/bin/tiny-bar")
            (e "${pkgs.wpaperd}/bin/wpaperd -d")
            (e "${pkgs.custom.matcha}/bin/matcha --daemon --off")
            (e "${pkgs.qbittorrent}/bin/qbittorrent")
          ];
      }
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config.common = {
      default = ["gtk"];
    };

    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];

      "org.freedesktop.impl.portal.FileChooser" = [
        "gtk"
      ];
    };
  };
}
