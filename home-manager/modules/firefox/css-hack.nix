{pkgs, ...}: let
  firefox-hack = pkgs.fetchFromGitHub {
    owner = "MrOtherGuy";
    repo = "firefox-csshacks";
    rev = "4e474a7191bd0a5f1526a256443e75b1655302ee";
    hash = "sha256-rQcSeaGd/KdpMHp4s3AYaLm3Z28StTSa/4LaiAaB4Xw=";
  };
  getFile = base: (file: builtins.readFile "${base}/${file}.css");
  collectFiles = fileGetter: (filenames: builtins.concatStringsSep "\n" (map fileGetter filenames));
in {
  applyChromes = collectFiles (getFile (firefox-hack + "/chrome"));
  applyContents = collectFiles (getFile (firefox-hack + "/content"));
}
