{prefix, pkgs, ...} : let 
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  satty = "${pkgs.satty}/bin/satty";
in pkgs.writeShellScriptBin "${prefix}-snap" ''
  ${grim} -g "$(${slurp})" - | ${satty} -f - 
''

