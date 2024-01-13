{ pkgs, ... }:

{
  imports = [ ./lang.nix ./web.nix ];

  home.packages = with pkgs; [
    gnumake
    docker
    httpie
    # postman

    # needed for building driver and access to postgres clis and lib
    postgresql_12_jit

    # IDE
    jetbrains.pycharm-professional
    jetbrains.datagrip
    jetbrains.webstorm

    # emacs specific packages
    sqlite # Org roam
    findutils # find, grep, etc
  ];

  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [ "--reuse-frame" "--no-wait" ];
    };
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29.override ({
      withTreeSitter = true;
      withSQLite3 = true;
      withXinput2 = true;
    });
  };
}
