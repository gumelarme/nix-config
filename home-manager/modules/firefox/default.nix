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
    programs.firefox = {
      enable = true;
      profiles.crockpot-browser = {
        isDefault = true;
        settings = {
          # allow user chrome
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
          default = "Google";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
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
              definedAliases = ["@np"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "Nix Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
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
              definedAliases = ["@no"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
            "YouTube" = {
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
              definedAliases = ["@yt"];
              icon = youtube-icon;
            };

            "Home Manager" = {
              urls = [
                {
                  template = "https://home-manager-options.extranix.com";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              definedAliases = ["@hm"];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            };
          };
        };
      };
    };
  };
}
