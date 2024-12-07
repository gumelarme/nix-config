{
  prefix,
  pkgs,
  source,
  ...
}: let
  qrencode = "${pkgs.qrencode}/bin/qrencode";
  feh = "${pkgs.feh}/bin/feh";
in
  pkgs.writeShellScriptBin "${prefix}-gen-qr" ''
    ${qrencode} -l H -d 75 -s 10 -o - "$(${source})" | ${feh} --scale-down -
  ''
