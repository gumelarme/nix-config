{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.firefox;
  youtube-icon = pkgs.fetchurl {
    url = "https://www.youtube.com/s/desktop/77953cee/img/favicon.ico";
    hash = "sha256-i7HQ+kOhdDbVndVG9vdMdtxEc13vdSLCLYAxFm24kR0";
  };
in {
  options.modules.firefox.enable = mkEnableOption "Enable firefox configuration";
  config = mkIf cfg.enable {
    home.file."${config.xdg.configHome}/tridactyl/tridactylrc".source = ./tridactylrc;
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [pkgs.tridactyl-native];

      profiles.guest = {
        id = 9;
        isDefault = false;
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          foxyproxy-standard
        ];
      };

      profiles.crockpot-browser = {
        isDefault = true;
        settings = {
          # allow user chrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Prevent swipe to go navigate back and forward in history
          "browser.gesture.swipe.left" = "cmd_scrollLeft";
          "browser.gesture.swipe.right" = "cmd_scrollRight";

          # Stop creating ~/Downloads!
          "browser.download.dir" = config.xdg.userDirs.download;

          # Show whole URL in address bar, prevent Disableit from trimming the protocol
          "browser.urlbar.trimURLs" = false;

          "browser.translations.automaticallyPopup" = false;
          "browser.shell.checkDefaultBrowser" = false;
          "browser.onboarding.enabled" = false; # "New to Firefox? Let's get started!" tour

          # Reduce search bar noises
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.shortcuts.bookmarks" = false;
          "browser.urlbar.shortcuts.history" = false;
          "browser.urlbar.shortcuts.tabs" = false;
          "browser.urlbar.showSearchSuggestionsFirst" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
        };
        userChrome = let
          firefox-hack = import ./css-hack.nix {inherit pkgs;};
        in
          firefox-hack.applyChromes [
            "window_control_placeholder_support"
            "hide_tabs_toolbar"
            "compact_urlbar_megabar"
            "privatemode_indicator_as_menu_button"
            "urlbar_container_color_border"
          ];
        search = {
          force = true;
          default = "google";
          engines = {
            "Nix Packages" = {
              definedAliases = ["@np"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Nix Options" = {
              definedAliases = ["@no"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "youtube" = {
              definedAliases = ["@yt"];
              icon = youtube-icon;
              urls = [
                {
                  template = "https://www.youtube.com/results";
                  params = [
                    {
                      name = "search_query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
            "Home Manager" = {
              definedAliases = ["@hm"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "release";
                      value = "master";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
            };
          };
        };
      };
    };
  };
}
