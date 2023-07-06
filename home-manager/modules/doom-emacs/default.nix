
{pkgs, ...}:

{
  # emacs specific packages
  home.packages = with pkgs; [
    sqlite
    gopls
    poetry
    nodePackages.pyright
    texlive.combined.scheme-full

    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];

  programs.doom-emacs = {
    enable = true;
    package = pkgs.emacs29.override({
      withPgtk = true;
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });

    doomPrivateDir = ./.doom.d;
  };
}
