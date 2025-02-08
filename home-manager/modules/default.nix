{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.hostname;
  packages =
    if pkgs.stdenv.isDarwin
    then pkgs.darwin-pkgs
    else pkgs;
in {
  options.modules.hostname = mkOption {
    type = types.str;
    description = "Hostname to be used in various config";
  };

  config = {
    home.sessionVariables.HOSTNAME = cfg;
    home.packages = with packages; [
      gh
      ttdl

      # System Utils
      fd
      tree
      less
      ripgrep
      ripgrep-all # for pdfs, zip, docx etc.
      coreutils
      wget
      curl
      fpp # Facebook Path Picker

      ## Nix
      statix # linter
      nurl
      nixos-option
      nix-prefetch-scripts

      ## Archive Helper
      atool
      zip
      unzip
      p7zip
      libarchive

      # File Management
      rsync
      rclone
      fdupes

      # Secrets
      rbw
      (
        if pkgs.stdenv.isDarwin
        then pinentry_mac
        else pinentry
      )

      # Misc
      glow
      btop
      termdown
      tealdeer
    ];
  };
}
