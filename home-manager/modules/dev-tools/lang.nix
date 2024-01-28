{ pkgs, ... }:

{
  home.packages = with pkgs; [
    texlive.combined.scheme-full
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))

    # typst
    fontforge
    typst
    typstfmt
    typst-lsp
  ];
}
