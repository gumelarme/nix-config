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
          firefox-chrome-hack = (pkgs.fetchFromGitHub {
                          owner = "MrOtherGuy";
                          repo = "firefox-csshacks";
                          rev = "2df24c36a2ca9d79783a4061ff6f98bb56131dc9";
                          hash = "sha256-QyB45dKbtLLs4FNeqNlL8RGq39mllWOLiCdqqqU5oxg=";
          }) + "/chrome";
          getChromeFile = file: builtins.readFile "${firefox-chrome-hack}/${file}.css";
          hacks = filenames: builtins.concatStringsSep "\n" (map getChromeFile filenames);
        in
          hacks [
            "window_control_placeholder_support"
            "hide_tabs_toolbar"
            "compact_urlbar_megabar"
            "privatemode_indicator_as_menu_button"
          ];
    };
  };
}
