{
  lib,
  pkgs,
  config,
  ...
}: let
  super = "SUPER";
  makeBinding = shortcut: action: let
    keys = lib.strings.splitString "+" shortcut;
    trigger = lib.lists.last keys;
    modifier = lib.strings.concatStringsSep " " (lib.lists.init keys);
  in "${super} ${modifier}, ${trigger}, ${action}";
  b = makeBinding; # Alias
  bp = shortcut: program: makeBinding shortcut "exec, ${program}";
  zeroTen = num:
    if num == "0"
    then "10"
    else num;
  ws = num: makeBinding num "focusworkspaceoncurrentmonitor, ${zeroTen num}";
  move = num: makeBinding "SHIFT+${num}" "movetoworkspacesilent, ${zeroTen num}";
  workspaces = map toString [
    1
    2
    3
    4
    5
    6
    7
    8
    9
    0
  ];
  specialWorkspace = key: name: [
    (b key "togglespecialworkspace, ${name}")
    (b "SHIFT+${key}" "movetoworkspace, special:${name}")
  ];

  # Programs
  terminal = "${pkgs.foot}/bin/foot -e tmux new -As default";
  fileManager = "${pkgs.xfce.thunar}/bin/thunar";
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";
  menu = "${rofi} -show drun";
  power-menu = "${rofi} -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
  browser = "${pkgs.firefox}/bin/firefox";
  browser-private = "${browser} --private-window";
in {
  bind =
    [
      (bp "Z" browser)
      (bp "R" menu)
      (bp "SHIFT+X" power-menu)
      (bp "T" fileManager)
      (bp "S" "crock-snap")
      (bp "SHIFT+Z" browser-private)
      (bp "SHIFT+Return" terminal)
      (bp "Backspace" "${pkgs.nixos-2411.ags}/bin/ags -t bar")

      (b "SHIFT+C" "killactive")
      (b "H" "movefocus, l")
      (b "L" "movefocus, r")
      (b "J" "layoutmsg, cyclenext")
      (b "K" "layoutmsg, cylcleprev")

      # Monitor
      (b "grave" "focusmonitor, +1")

      # Layout
      (b "Return" "layoutmsg, swapwithmaster")
      (b "P" "pin")
      (b "V" "togglefloating")
      (b "F" "fullscreen, 1")
      (b "semicolon" "cyclenext, next") # include both floating and tiled
      (b "comma" "layoutmsg, orientationnext") # master

      # Resize, move to bottom-left, and pin
      (b "SHIFT+P" "setfloating, 1")
      (b "SHIFT+P" "resizeactive, exact 10% 10%")
      (b "SHIFT+P" "movewindow, r")
      (b "SHIFT+P" "movewindow, b")
      (b "SHIFT+P" "movewindowpixel, -20 -20, activewindow")
      (b "SHIFT+P" "pin")
      (b "SHIFT+P" "focuscurrentorlast")

      # Group
      (b "G" "togglegroup")
      (b "SHIFT+CONTROL+G" "lockactivegroup, toggle")
      (b "Tab" "changegroupactive, f")
      (b "SHIFT+Tab" "changegroupactive, b")

      # (b "SHIFT+grave" "hyprexpo:expo, toggle")
    ]
    ++ (map ws workspaces)
    ++ (map move workspaces)
    ++ specialWorkspace "backslash" "scratch"
    ++ specialWorkspace "period" "hidden";

  bindel = let
    resize = key: delta: makeBinding "SHIFT+${key}" "resizeactive, ${delta}";
  in [
    (resize "H" "-10 0")
    (resize "L" "10 0")
    (resize "J" "0 10")
    (resize "K" "0 -10")
    ", XF86AudioRaiseVolume, exec, crock-volume 5%+"
    ", XF86AudioLowerVolume, exec, crock-volume 5%-"
    ", XF86AudioMute, exec, crock-volume toggle"
    ", XF86AudioMicMute, exec, crock-mic-toggle"
    ", XF86MonBrightnessUp, exec, crock-brightness 5%+"
    ", XF86MonBrightnessDown, exec, crock-brightness 5%-"
  ];

  bindm = [
    (b "mouse:272" "movewindow")
    (b "mouse:273" "resizewindow")
  ];
}
