{pkgs, config, ... }:
{
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override({ withNerdIcons = true; });
    extraPackages = with pkgs; [ glow libnotify mediainfo viu ];
    bookmarks =
      let
        userDirs = config.xdg.userDirs;
        extra = userDirs.extraConfig;
      in
        {
          d = "${userDirs.download}";
          v = "${extra.XDG_DEV_DIR}";
          r = "${extra.XDG_DEV_DIR}/repo";
          s = "${extra.XDG_SCREENSHOT_DIR}";
        };

    plugins = {
      mappings = {
          f = "fzcd";
          v = ".ntfy";
          m = "nmount";
          p = "preview-tui";
          r = "gitroot";
      };

      src = (pkgs.fetchFromGitHub {
          owner = "jarun";
          repo = "nnn";
          rev = "v4.8";
          sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
      }) + "/plugins";
    };
  };
}
