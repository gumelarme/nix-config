{
  config,
  lib,
  ...
}: let
  cfg = config.modules.neovim;
in {
  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.wilder = {
      enable = true;
      modes = [":" "/" "?"];
      renderer = ''
        wilder.popupmenu_renderer({
          highlighter = wilder.basic_highlighter(),
          left = {' ', wilder.popupmenu_devicons()},
          right = {' ', wilder.popupmenu_scrollbar()},
          max_height = '20%', -- to set a fixed height, set min_height to the same value
          reverse = 0,        -- if 1, shows the candidates from bottom to top
          pumblend = 0,       -- remove transparency
          highlights = {
            accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#f59cff'}}),
          },
        })
      '';
    };
  };
}
