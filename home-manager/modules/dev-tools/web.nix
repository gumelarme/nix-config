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
  };

  config = mkIf cfg.enable {
    home.file."${config.home.homeDirectory}/.npmrc" = {
      text = ''
        registry = https://registry.npmjs.org
        registry = http://registry.npmmirror.com
      '';
    };

    home.packages = with pkgs; [
      html-tidy
      typescript
      nodejs_20
      nodePackages.pnpm
      nodePackages.js-beautify
      nodePackages.stylelint
      nodePackages.typescript-language-server
      nodePackages."@astrojs/language-server"
      nodePackages.volar
    ];
  };
}
