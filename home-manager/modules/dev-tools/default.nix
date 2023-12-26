{ pkgs, ... }:

{
  imports = [
    ./python.nix
    ./web.nix
  ];

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
  ]; 
}
