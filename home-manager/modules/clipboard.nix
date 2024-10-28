{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.clipboard;
in {
  options.modules.clipboard = {
    enable = mkEnableOption "Enable xclip with pbcopy/pbpaste utilities";
  };
  config = mkIf cfg.enable {
    home.packages = [pkgs.wl-clipboard];
    programs.zsh = {
      shellAliases = {
        # pbcopy = "xclip -selection clipboard";
        # pbpaste = "xclip -selection clipboard -o";
        pbcopy = "wl-copy";
        pbpaste = "wl-paste";
      };
    };
  };
}
