# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example' or (legacy) 'nix-build -A example'
# {pkgs ? (import ../nixpkgs.nix) {}}: { }
{pkgs}: {
  kasuari-wallpapers = pkgs.stdenvNoCC.mkDerivation (_final: {
    pname = "kasuari-wallpapers";
    version = "0.1";

    dontUnpack = true;
    src = pkgs.fetchurl {
      url = "https://f003.backblazeb2.com/file/squirrel-stash/wallpapers/kumamon.png";
      hash = "sha256-A0x4VbfRuPY6b6d/L/N9k9xIsoIjEeFgzyFkfvcYanc";
    };

    installPhase = ''
      mkdir -p $out/img
      cp $src $out/img/kumamon.png
    '';

    meta = {
      description = "Wallpapers fetched from S3 url";
    };
  });
}
