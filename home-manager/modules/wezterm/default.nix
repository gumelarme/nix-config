{ config, lib, ... }:
with lib;
let cfg = config.modules.wezterm;
in {
  options.modules.wezterm = {
    enable = mkEnableOption "Wezterm Modules";
    configOnly = mkOption {
      default = false;
      type = types.bool;
      description = ''
        If true it will not install wezterm, only copy the config
        There is some building issue in darwin,
        for now its better to install wezterm manually but still manage the config file.
      '';
    };
  };

  # TODO: Improve readability
  config = mkMerge [
    (mkIf (cfg.enable && cfg.configOnly) {
      home.file."${home.homeDirectory}/.config/wezterm/wezterm.lua".source =
        ./wezterm.lua;
    })

    (mkIf (cfg.enable && !cfg.configOnly) {
      programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ./wezterm.lua;
      };
    })
  ];
}
