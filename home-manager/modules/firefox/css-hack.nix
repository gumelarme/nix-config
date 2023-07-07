{ pkgs, ... }:

let
  firefox-hack = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "firefox-csshacks";
    rev = "2df24c36a2ca9d79783a4061ff6f98bb56131dc9";
    hash = "sha256-QyB45dKbtLLs4FNeqNlL8RGq39mllWOLiCdqqqU5oxg=";
  };
  getFile = base: (file: builtins.readFile "${base}/${file}.css");
  collectFiles = fileGetter:
    (filenames: builtins.concatStringsSep "\n" (map fileGetter filenames));
in {
  applyChromes = collectFiles (getFile (firefox-hack + "/chrome"));
  applyContents = collectFiles (getFile (firefox-hack + "/content"));
}
