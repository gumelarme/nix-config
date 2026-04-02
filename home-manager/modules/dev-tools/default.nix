{pkgs, ...}: {
  imports = [
    ./clojure
    ./elm.nix
    ./emacs.nix
    ./nix.nix
    ./python.nix
    ./web.nix
    ./go.nix
    ./intellimacs.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [
    cachix
    gnumake
    httpie
    hurl
    shellcheck
    shfmt
  ];

  programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "Maple Mono NF CN Medium:size=8";
        dpi-aware = "yes";
        pad = "5x2"; # padding
      };

      colors-dark = {
        alpha = 0.92;
        background = "282a36";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
