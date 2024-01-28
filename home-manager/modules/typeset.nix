{pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.typeset;
    in
{
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
      (mkIf cfg.latex.enable [
        texlive.combined.scheme-full
        (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
      ])

      (mkIf cfg.typst.enable [
          typst
          typstfmt
          typst-lsp
      ])
    ]);
  };
}
