{ pkgs, ... }:

{
  home.packages = [ pkgs.haskellPackages.greenclip ];
  systemd.user.services.greenclip = {
    Unit = {
      Description = "greenclip daemon";
      After = [ "display-manager.service" ]; # X11
    };
    Service = {
      Type = "forking";
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip  daemon";
      Restart = "always";
    };
    Install = { WantedBy = [ "default.target" ]; };
  };
}
