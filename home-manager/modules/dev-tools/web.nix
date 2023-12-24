{ pkgs, ... }: {
  home.packages = with pkgs; [
    html-tidy

    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-language-server

    typescript
    nodejs_20
    nodePackages.pnpm
    nodePackages.js-beautify
    nodePackages.stylelint
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages."@astrojs/language-server"
    nodePackages.volar
    # (nodePackages."@astrojs/language-server".override {
    #   version = "1.0.8";
    #   src = fetchurl {
    #     url =
    #       "https://registry.npmjs.org/@astrojs/language-server/-/language-server-1.0.8.tgz";
    #     hash =
    #       "sha512-gssRxLGb8XnvKpqSzrDW5jdzdFnXD7eBXVkPCkkt2hv7Qzb+SAzv6hVgMok3jDCxpR1aeB+XNd9Qszj2h29iog==";
    #   };
    # })
  ];
}
