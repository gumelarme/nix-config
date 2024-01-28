{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.nnn;
in {
  options.modules.nnn = {
    enable = mkEnableOption "Enable nnn modules";
    bookmarks = mkOption {
      type = with types; attrsOf str;
      description = ''
        Directory bookmarks.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.nnn = {
      inherit (cfg) bookmarks;
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      extraPackages = with pkgs; [glow libnotify mediainfo viu];
      plugins = {
        mappings = {
          f = "fzcd";
          v = ".ntfy";
          m = "nmount";
          p = "preview-tui";
          r = "gitroot";
        };

        src =
          (pkgs.fetchFromGitHub {
            owner = "jarun";
            repo = "nnn";
            rev = "v4.8";
            sha256 = "sha256-QbKW2wjhUNej3zoX18LdeUHqjNLYhEKyvPH2MXzp/iQ=";
          })
          + "/plugins";
      };
    };
  };
}
