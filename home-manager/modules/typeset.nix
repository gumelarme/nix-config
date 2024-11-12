{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.typeset;
in {
  options.modules.typeset = {
    latex = {
      enable = mkEnableOption "Enable latex module";
      package = mkOption {
        type = types.package;
        default = texlive.combined.scheme-full;
        description = "Latex package to be installed";
      };
    };

    typst = {
      enable = mkEnableOption "Enable typst module";
    };
  };

  config = {
    home.packages = mkMerge (with pkgs; [
      (mkIf (cfg.latex.enable || cfg.typst.enable) [
        symbola
        corefonts
        wqy_zenhei
        wqy_microhei
        # TODO: Find SimSun bold
        # TODO: Add more CJK fonts, Fandol, Fang etc
      ])

      (mkIf cfg.latex.enable [
        stable.texlive.combined.scheme-full
        (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
      ])

      (mkIf cfg.typst.enable [
        stable.typst
        stable.typstfmt
        stable.typst-lsp
      ])
    ]);
  };
}
