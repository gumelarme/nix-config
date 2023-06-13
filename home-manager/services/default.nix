{pkgs, ... }:

{
  imports = [
    ./dunst.nix
  ];

  services.picom = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = ["--gui-address=:12300"];
    # tray.enable = true;
  };
}
