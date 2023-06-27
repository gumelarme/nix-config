{ lib, config, ... }:
{
  xdg.userDirs  = let home = config.home.homeDirectory; in {
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
      XDG_DEV_DIR = "${home}/dev";
      XDG_DEVTOOLS_DIR = "${home}/dev/tools";
      XDG_SCREENSHOT_DIR = "${config.xdg.userDirs.pictures}/screenshot";
    };
  };

  xdg.mime.enable = true;
  xdg.desktopEntries = {
    nvim_terminal = {
      name = "Neovim (with terminal)";
      comment = "Neovim opened with terminal";
      genericName = "Text editor";
      exec = "wezterm -e nvim %f";
      terminal = true;
      categories = ["Development" "TextEditor"];
      mimeType = ["text/*"];
    };
  };
}
