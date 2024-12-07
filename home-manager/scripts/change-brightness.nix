{
  prefix,
  pkgs,
  ...
}: let
  tag = "${prefix}-brightness";
  ctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
  dunstify = "${pkgs.dunst}/bin/dunstify";
  tr = "${pkgs.coreutils}/bin/tr";
  grep = "${pkgs.gnugrep}/bin/grep";
  timeout = 1000;
in
  pkgs.writeShellScriptBin "${prefix}-brightness" ''
    # Perform action, then query result
    ${ctl} set "$@" > /dev/null
    brightness=$(${ctl} -m | ${grep} -P '\d+%' --only-matching | ${tr} -d %)

    # Show the brightness notification
    ${dunstify} -a "changeBrightness" -t ${toString timeout} -u low -i display-brightness -h string:x-dunst-stack-tag:''$${tag} -h int:value:"$brightness" "Brightness: ''${brightness}/100"

    # Play the brightness changed sound
    ${play} -i audio-volume-change -d "changeBrightness"
  ''
