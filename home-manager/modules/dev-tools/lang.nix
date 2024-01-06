{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gopls
    nixfmt

    # Python
    python3Full
    poetry
    black
    isort
    pipenv

    texlive.combined.scheme-full
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))

    # typst
    fontforge
    typst
    typstfmt
    typst-lsp
  ];
}
