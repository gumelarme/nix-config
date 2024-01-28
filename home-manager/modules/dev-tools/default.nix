{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.dev-tools;
in {
  imports = [./emacs.nix];

  options.modules.dev-tools = {
    nix = {enable = mkEnableOption "Enable nix development tools";};
    elm = {enable = mkEnableOption "Enable elm development tools";};
    web = {enable = mkEnableOption "Enable web development tools";};
    emacs = {enable = mkEnableOption "Enable emacs development tools";};
    python = {
      enable = mkEnableOption "Enable python development tools";
      package = mkOption {
        type = types.package;
        default = pkgs.python3Full;
        description = "Python package to install, default will follow nix stable version";
      };
    };
  };

  config = let
    defaultPackages = with pkgs; [httpie gnumake];
  in {
    programs.zsh.shellAliases = mkIf cfg.nix.enable {"nixfmt" = "alejandra";};
    home.packages = mkMerge [
      defaultPackages
      (mkIf cfg.nix.enable (with pkgs; [alejandra nil]))
      (mkIf cfg.python.enable
        (with pkgs; [cfg.python.package poetry black isort pipenv]))

      (mkIf cfg.elm.enable (with pkgs; [
        elmPackages.elm
        elmPackages.elm-format
        elmPackages.elm-language-server
      ]))

      (mkIf cfg.web.enable (with pkgs; [
        html-tidy
        typescript
        nodejs_20
        nodePackages.pnpm
        nodePackages.js-beautify
        nodePackages.stylelint
        nodePackages.pyright
        nodePackages.typescript-language-server
        nodePackages."@astrojs/language-server"
        nodePackages.volar
      ]))
    ];
  };
}
