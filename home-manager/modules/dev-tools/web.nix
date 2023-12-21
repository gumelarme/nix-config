{ pkgs, ... }:
{
  home.packages = with pkgs; [
    html-tidy

    nodejs_20
    nodePackages.pnpm
    nodePackages.js-beautify
    nodePackages.stylelint
  ];
}
