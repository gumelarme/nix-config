_: {
  programs.nixvim.plugins.smear-cursor = {
    enable = true;
    settings = {
      stiffness = 0.5; # 0.6      [0, 1]
      trailing_stiffness = 0.5; # 0.3      [0, 1]
      distance_stop_animating = 0.5; # 0.1      > 0
      hide_target_hack = false; # true     boolean
      legacy_computing_symbols_support = true;
      transparent_bg_fallback_color = "#303030";
    };
  };
}
