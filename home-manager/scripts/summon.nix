{prefix, pkgs, ...} : pkgs.writeShellScriptBin "${prefix}-summon" ''
  nohup "$@" > /dev/null 2>&1 &
''

