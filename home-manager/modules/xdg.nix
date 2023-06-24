{ lib, config, ... }:
{
  xdg.userDirs  = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/desktop";

    documents = "${config.home.homeDirectory}/docs";

    download = "${config.home.homeDirectory}/downloads";
    music = "${config.home.homeDirectory}/musics";
    pictures = "${config.home.homeDirectory}/pics";
    publicShare = "${config.home.homeDirectory}/public";
    templates = "${config.home.homeDirectory}/templates";
    videos = "${config.home.homeDirectory}/videos";
    extraConfig = {
      XDG_DEV_DIR = "${config.home.homeDirectory}/dev";
      XDG_DEVTOOLS_DIR = "${config.home.homeDirectory}/dev/tools";
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
