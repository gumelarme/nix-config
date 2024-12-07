{config, ...}: {
  imports = [./mime.nix];

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
      XDG_SYNC_DIR = "${home}/sync";
      XDG_SYNC_DEFAULT_DIR = "${home}/sync/${config.home.username}";
      XDG_ORGNOTES_DIR = "${home}/sync/org";
      XDG_DEV_DIR = "${home}/dev";
      XDG_DEVTOOLS_DIR = "${home}/dev/tools";
      XDG_SCREENSHOT_DIR = "${config.xdg.userDirs.pictures}/screenshot";
    };
  };

  xdg.mime.enable = true;
}
