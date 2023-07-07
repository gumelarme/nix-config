{pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.crockpot-browser = {

      isDefault = true;
      settings = {
        # allow user chrome
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome =
          let
            firefox-hack = import ./css-hack.nix { inherit pkgs; };
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
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
        };
      };
    };
  };
}
