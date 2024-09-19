{...}: {
  general = {
    gaps_in = 3;
    gaps_out = 10;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = false;
    allow_tearing = false;
    layout = "master";
    resize_corner = 1; # resize floating window from topleft;
  };

  group = {
    groupbar = {
      height = 16;
      font_size = 9;
      text_color = "0xff1a1a1a";
      "col.active" = "0xffff79c6";
      "col.inactive" = "0xff853e67";
      "col.locked_active" = "0xffbd93f9";
      "col.locked_inactive" = "0xff4b346e";
    };
  };

  decoration = {
    rounding = 5;
    active_opacity = 1.0;
    inactive_opacity = 1.0;
    drop_shadow = true;
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };

  animations = {
    enabled = true;
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    animation = [
      "windows, 1, 2, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  windowrulev2 = [
    "suppressevent maximize, class:.*"
    "suppressevent fullscreen, class:.*"
  ];
}
