
{prefix, pkgs, ...} : let 
  tag = "${prefix}-mic-toggle";
  ctl = "${pkgs.wireplumber}/bin/wpctl";
  play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
  dunstify = "${pkgs.dunst}/bin/dunstify";
  awk = "${pkgs.gawk}/bin/awk";
  timeout = 1000;
in pkgs.writeShellScriptBin "${prefix}-mic-toggle" ''
  ${ctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle > /dev/null

  mic_status=$(${ctl} get-volume @DEFAULT_AUDIO_SOURCE@ | ${awk} '{print $3}')

  # Show the mic_status notification
  ${dunstify} -a "changeMic" -t ${toString timeout} -u low -i audio-input-microphone -h string:x-dunst-stack-tag:${tag} "Mic: ''${mic_status}"


  # Play the mic_status changed sound
  ${play} -i audio-volume-change -d "changeMic"
''

