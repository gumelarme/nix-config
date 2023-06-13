{pkgs, ... }:

{
  imports = [
    ./dunst.nix
  ];

  services.network-manager-applet.enable = true;

  services.picom = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    extraOptions = ["--gui-address=:12300"];
    # tray.enable = true;
  };

}
