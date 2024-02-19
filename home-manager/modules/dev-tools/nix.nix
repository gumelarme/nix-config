{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.nix;
in {
  options.modules.dev-tools.nix = {
    enable = mkEnableOption "Enable nix development tools";
  };

  config = mkIf cfg.enable {
    programs.zsh.shellAliases = {"nixfmt" = "alejandra";};
    home.packages = with pkgs; [
      alejandra
      nil
    ];
  };
}
