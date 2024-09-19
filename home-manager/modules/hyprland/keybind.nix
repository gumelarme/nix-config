{lib, ...}: let
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
  workspaces = map toString [1 2 3 4 5 6 7 8 9 0];
  specialWorkspace = key: name: [
    (b key "togglespecialworkspace, ${name}")
    (b "SHIFT+${key}" "movetoworkspace, special:${name}")
  ];

  # Programs
  terminal = "wezterm -e tmux new -As default";
  fileManager = "thunar";
  menu = "wofi --show drun";
  browser = "firefox";
  browser-private = "firefox --private-window";
in {
  bind =
    [
      (bp "Z" browser)
      (bp "R" menu)
      (bp "T" fileManager)
      (bp "SHIFT+R" browser-private)
      (bp "SHIFT+Return" terminal)

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

      # Group
      (b "G" "togglegroup")
      (b "G" "lockactivegroup, toggle")
      (b "Tab" "changegroupactive, f")
      (b "Tab" "changegroupactive, b ")

    ]
    ++ (map ws workspaces)
    ++ (map move workspaces)
    ++ specialWorkspace "backslash" "scratch"
    ++ specialWorkspace "S" "magic";

  bindel = 
    let 
      resize = key: delta: makeBinding "SHIFT+${key}" "resizeactive, ${delta}";
    in
    [
      (resize "H" "-10 0")
      (resize "L" "10 0")
      (resize "J" "0 10")
      (resize "K" "0 -10")
      ", XF86AudioRaiseVolume, exec, crock volume +5%"
      ", XF86AudioLowerVolume, exec, crock volume -5%"
      ", XF86AudioMute, exec, crock volume toggle"
      ", XF86AudioMicMute, exec, crock mic-toggle"
      ", XF86MonBrightnessUp, exec, crock brightness set 5%+"
      ", XF86MonBrightnessDown, exec, crock brightness set 5%-"
  ];

  bindm = [
    (b "mouse:272" "movewindow")
    (b "mouse:273" "resizewindow")
  ];
}
