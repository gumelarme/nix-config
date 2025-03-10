{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.emacs;
in {
  options.modules.dev-tools.emacs = {
    enable = mkEnableOption "Enable emacs development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lv
      sqlite # Org roam
      findutils # find, grep, etc
    ];

    services.emacs = {
      enable = true;
      client = {
        enable = true;
        arguments = ["--reuse-frame" "--no-wait"];
      };
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs30.override {
        withTreeSitter = true;
        withSQLite3 = true;
        withXinput2 = true;
      };
    };
  };
}
