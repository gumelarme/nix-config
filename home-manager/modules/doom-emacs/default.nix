{ pkgs, ... }:

{
  # emacs specific packages
  home.packages = with pkgs; [
    gopls
    poetry
    nixfmt
    sqlite # Org roam
    findutils

    texlive.combined.scheme-full
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.override ({
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });
  };
}
