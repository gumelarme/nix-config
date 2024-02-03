{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hostname;
in {
  imports = [
    ./packages.nix
    ./clipboard.nix
    ./fonts.nix
    ./typeset.nix

    ./eww
    ./nvim
    ./tmux
    ./rofi
    ./shell
    ./firefox
    ./wezterm
    ./dev-tools
  ];

  options.modules.hostname = mkOption {
    type = types.str;
    description = "Hostname to be used in various config";
  };

  config = {
    home.sessionVariables.HOSTNAME = cfg;
  };

}
