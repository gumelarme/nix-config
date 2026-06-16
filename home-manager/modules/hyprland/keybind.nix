{
  lib,
  pkgs,
  config,
  ...
}: let
  lua = lib.generators.mkLuaInline;
  bind = key: dispatcher: {_args = ["SUPER + ${key}" dispatcher];};
  bindOpt = key: dispatcher: opt: {_args = ["SUPER + ${key}" dispatcher opt];};
  bindRepeat = key: dispatcher: bindOpt key dispatcher {repeating = true;};
  dsp = {
    exec = bin: lua ''hl.dsp.exec_cmd("${bin}")'';
    close = lua "hl.dsp.window.close()";
    pin = lua ''hl.dsp.window.pin()'';
    move-focus = dir: lua ''hl.dsp.focus({ direction = "${dir}"})'';
    switch-monitor = lua ''hl.dsp.focus({ monitor = "+1"})'';
    layout-msg = msg: lua ''hl.dsp.layout("${msg}")'';
    fullscreen = lua ''hl.dsp.window.fullscreen({ action = "toggle" })'';
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    workspace = ws: lua ''hl.dsp.focus({ workspace = "${ws}", on_current_monitor = true })'';
    move-to-workspace = ws: lua ''hl.dsp.window.move({ workspace = "${ws}", follow = false })'';
    toggle-special = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    resize = x: y: lua ''hl.dsp.window.resize({ x = ${toString x}, y = ${toString y}, relative = true })'';
    toggle-group = lua ''hl.dsp.group.toggle()'';
    lock-group = lua ''hl.dsp.group.lock_active()'';
    next-group-member = lua ''hl.dsp.group.next()'';
    prev-group-member = lua ''hl.dsp.group.prev()'';

    mouse-drag = lua ''hl.dsp.window.drag()'';
    mouse-resize = lua ''hl.dsp.window.resize()'';
  };
  # workspace utils
  zeroTen = num:
    if num == "0"
    then "10"
    else num;

  workspaces = map toString [1 2 3 4 5 6 7 8 9 0];
  switchWorkspace = ws: (bind ws (dsp.workspace (zeroTen ws)));
  moveToWorkspace = ws: (bind "SHIFT + ${ws}" (dsp.move-to-workspace (zeroTen ws)));

  # -- programs
  rofi = "${config.programs.rofi.finalPackage}/bin/rofi";
  menu = "${rofi} -show drun";
  terminal = "foot -e tmux new -As default";
  fileManager = "${pkgs.thunar}/bin/thunar";
  clipman = "${rofi} -modi clipboard:${pkgs.cliphist}/bin/cliphist-rofi -show clipboard";
  power-menu = "${rofi} -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
  browser = "${pkgs.firefox}/bin/firefox";
  browser-private = "${browser} --private-window";
in {
  # Symbols list https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h
  bind =
    [
      # Controls
      ## Movement
      (bind "SHIFT + C" dsp.close)
      (bind "H" (dsp.move-focus "l"))
      (bind "L" (dsp.move-focus "r"))
      (bind "J" (dsp.layout-msg "cyclenext"))
      (bind "K" (dsp.layout-msg "cycleprev"))
      (bind "Return" (dsp.layout-msg "swapwithmaster"))
      (bind "comma" (dsp.layout-msg "orientationnext"))
      (bind "grave" dsp.switch-monitor)

      ## Windows
      (bind "F" dsp.fullscreen)
      (bind "SHIFT + F" dsp.float)
      (bind "P" dsp.pin)
      (bindRepeat "SHIFT + H" (dsp.resize (-10) 0))
      (bindRepeat "SHIFT + L" (dsp.resize 10 0))
      (bindRepeat "SHIFT + J" (dsp.resize 0 10))
      (bindRepeat "SHIFT + K" (dsp.resize 0 (-10)))

      ## L M R = 272 274 273
      (bindOpt "mouse:274" dsp.mouse-drag {mouse = true;})
      (bindOpt "mouse:273" dsp.mouse-resize {mouse = true;})

      ## Group
      (bind "G" dsp.toggle-group)
      (bind "SHIFT + G" dsp.lock-group)
      (bind "Tab" dsp.next-group-member)
      (bind "SHIFT + Tab" dsp.prev-group-member)

      # Programs
      (bind "SHIFT + Return" (dsp.exec terminal))
      (bind "R" (dsp.exec menu))
      (bind "T" (dsp.exec fileManager))
      (bind "Z" (dsp.exec browser))
      (bind "SHIFT + Z " (dsp.exec browser-private))
      (bind "S" (dsp.exec "crock-snap"))
      (bind "SHIFT + X" (dsp.exec power-menu))
      (bind "V" (dsp.exec clipman))

      # Special Workspace
      (bind "backslash" (dsp.toggle-special "scratch"))
      (bind "SHIFT + backslash" (dsp.move-to-workspace "special:scratch"))

      (bind "period" (dsp.toggle-special "hidden"))
      (bind "SHIFT + period" (dsp.move-to-workspace "special:hidden"))

      (bind "minus" (dsp.toggle-special "tools"))
      (bind "SHIFT + minus" (dsp.move-to-workspace "special:tools"))
    ]
    ++ (map switchWorkspace workspaces)
    ++ (map moveToWorkspace workspaces)
    ++ (
      let
        bindRepeat = key: dispatcher: {_args = [key dispatcher {repeating = true;}];};
      in [
        # Function Keys
        (bindRepeat "XF86AudioRaiseVolume" (dsp.exec "crock-volume 5%+"))
        (bindRepeat "XF86AudioLowerVolume" (dsp.exec "crock-volume 5%-"))
        (bindRepeat "XF86AudioMute" (dsp.exec "crock-volume toggle"))
        (bindRepeat "XF86AudioMicMute" (dsp.exec "crock-mic-toggle"))
        (bindRepeat "XF86MonBrightnessUp" (dsp.exec "crock-brightness 5%+"))
        (bindRepeat "XF86MonBrightnessDown" (dsp.exec "crock-brightness 5%-"))
      ]
    )
    ++ (
      # this toggle all the available tiny-bar at once
      # TODO: toggle depending on mouse position
      let
        ags = "${pkgs.ags}/bin/ags";
        jq = "${pkgs.jq}/bin/jq";
        jq_command = ''${jq} '\"${ags} toggle tiny-bar-\\(.[].id)\"' '';
      in [
        (bind "Backspace" (dsp.exec "hyprctl monitors -j | ${jq_command} | xargs -I{} bash -c {}"))
        (bind "SHIFT+Backspace" (dsp.exec "${pkgs.custom.tiny-bar}/bin/tiny-bar"))
      ]
    );
}
# TODO translate to lua
# # Resize, move to bottom-left, and pin
# (b "SHIFT+P" "setfloating, 1")
# (b "SHIFT+P" "resizeactive, exact 10% 10%")
# (b "SHIFT+P" "movewindow, r")
# (b "SHIFT+P" "movewindow, b")
# (b "SHIFT+P" "movewindowpixel, -20 -20, activewindow")
# (b "SHIFT+P" "pin")
# (b "SHIFT+P" "focuscurrentorlast")

