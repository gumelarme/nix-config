{config, ...}: {
  imports = [./mime.nix];
  xdg.enable = true;
  xdg.userDirs = let
    home = config.home.homeDirectory;
  in {
    enable = true;
    createDirectories = true;
    desktop = "${home}/desktop";
    documents = "${home}/docs";
    download = "${home}/downloads";
    music = "${home}/musics";
    pictures = "${home}/pics";
    publicShare = "${home}/public";
    templates = "${home}/templates";
    videos = "${home}/videos";
    extraConfig = {
      CONFIG_HOME = config.xdg.configHome;
      SYNC = "${home}/sync";
      SYNC_DEFAULT = "${home}/sync/${config.home.username}";
      ORGNOTES = "${home}/sync/org";
      DEV = "${home}/dev";
      DEVTOOLS = "${home}/dev/tools";
      SCREENSHOT = "${config.xdg.userDirs.pictures}/screenshot";
    };
  };

  xdg.mime.enable = true;
}
