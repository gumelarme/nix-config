{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.clojure;
in {
  options.modules.dev-tools.clojure = {
    enable = mkEnableOption "Enable clojure development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jdk17_headless
      clojure-lsp
      cljfmt
      semgrep
    ];
  };
}
