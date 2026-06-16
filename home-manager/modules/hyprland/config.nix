_: {
  config = {
    general = {
      layout = "master";
      gaps_in = 3;
      gaps_out = 10;
      border_size = 2;
      resize_on_border = false;
      allow_tearing = true;
      "col.inactive_border" = "#595959aa";
      "col.active_border" = {
        colors = ["#33ccffee" "#00ff99ee"];
        angle = 45;
      };
    };

    decoration = {
      rounding = 5;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      dim_special = 0.5;

      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
        color = "#1a1a1aee";
      };
    };

    group = {
      group_on_movetoworkspace = true;
      groupbar = {
        enabled = true;
        gradients = true;
        height = 18;
        font_size = 12;
        font_family = "DejaVu Sans Mono";
        text_color = "0xff1a1a1a";
        "col.active" = "0xffff79c6";
        "col.inactive" = "0xff853e67";
        "col.locked_active" = "0xffbd93f9";
        "col.locked_inactive" = "0xff4b346e";
      };
    };
  };
}
