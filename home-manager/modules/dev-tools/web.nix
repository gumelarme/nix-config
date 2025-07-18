{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools.web;
in {
  options.modules.dev-tools.web = {
    enable = mkEnableOption "Enable web development tools";
    configOnly = mkEnableOption "Copy npmrc config only";
  };

  config = mkIf cfg.enable {
    home.file."${config.home.homeDirectory}/.npmrc" = {
      text = ''
        registry = https://registry.npmjs.org
      '';
      # registry = http://registry.npmmirror.com
      # registry = http://mirrors.cloud.tencent.com/npm/
    };

    home.packages = mkIf (!cfg.configOnly) (with pkgs; [
      html-tidy
      typescript
      nodejs_20
      nodePackages.pnpm
      nodePackages.js-beautify
      nodePackages.stylelint
      nodePackages.typescript-language-server
      nodePackages."@astrojs/language-server"
      # nodePackages.volar
    ]);
  };
}
