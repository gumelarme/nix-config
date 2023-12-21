{ pkgs, ... }:

{
  # emacs specific packages
  home.packages = with pkgs; [
    gopls
    poetry
    nixfmt
    sqlite # Org roam
    findutils
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages."@astrojs/language-server"

    # (nodePackages."@astrojs/language-server".override {
    #   version = "1.0.8";
    #   src = fetchurl {
    #     url =
    #       "https://registry.npmjs.org/@astrojs/language-server/-/language-server-1.0.8.tgz";
    #     hash =
    #       "sha512-gssRxLGb8XnvKpqSzrDW5jdzdFnXD7eBXVkPCkkt2hv7Qzb+SAzv6hVgMok3jDCxpR1aeB+XNd9Qszj2h29iog==";
    #   };
    # })
    nodePackages.volar
    texlive.combined.scheme-full
    (tree-sitter.withPlugins (_: tree-sitter.allGrammars))
  ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.override ({
      # withPgtk = true;
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });

    extraPackages = e: [
      e.nerd-icons
      e.nerd-icons-completion
      e.nerd-icons-dired
      e.nerd-icons-ibuffer
      e.nerd-icons-ivy-rich
    ];
  };
}
