{ pkgs, config, lib, ... }:
with lib;
let cfg = config.modules.clipboard;
in {
  options.modules.clipboard = {
    enable = mkEnableOption "Enable xclip with pbcopy/pbpaste utilities";
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.xclip ];
    programs.zsh = {
      shellAliases = {
        pbcopy = "xclip -selection clipboard";
        pbpaste = "xclip -selection clipboard -o";
      };
    };
  };
}
