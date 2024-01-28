{
  pkgs,
  config,
  ...
}: {
  home.packages = [pkgs.haskellPackages.greenclip];
  home.file."${config.xdg.configHome}/greenclip.toml" = {
    source = ./greenclip.toml;
  };

  systemd.user.services.greenclip = {
    Unit = {
      Description = "greenclip daemon";
      After = ["display-manager.service"]; # X11
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.haskellPackages.greenclip}/bin/greenclip daemon";
      Restart = "on-failure";
    };
    Install = {WantedBy = ["default.target"];};
  };
}
