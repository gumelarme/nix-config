{
  prefix,
  pkgs,
  ...
}: let
  tag = "${prefix}-volume";
  ctl = "${pkgs.wireplumber}/bin/wpctl";
  play = "${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play";
  dunstify = "${pkgs.dunst}/bin/dunstify";
  awk = "${pkgs.gawk}/bin/awk";
  cut = "${pkgs.coreutils}/bin/cut";
  timeout = 1000;
in
  pkgs.writeShellScriptBin "${prefix}-volume" ''
    # Perform action, then query result

    if [[ "$@" == "toggle" ]]; then
      ${ctl} set-mute @DEFAULT_AUDIO_SINK@ toggle > /dev/null;
    else
      ${ctl} set-mute @DEFAULT_AUDIO_SINK@ 0 > /dev/null;
      ${ctl} set-volume @DEFAULT_AUDIO_SINK@ "$@" > /dev/null;
    fi

    volume="$(${ctl} get-volume @DEFAULT_AUDIO_SINK@ | ${awk} '{print $2}' | ${cut} -d '.' -f 2)"
    mute="$(${ctl} get-volume @DEFAULT_AUDIO_SINK@ | ${awk} '{print $3}')"

    if [[ $volume == 0 || "$mute" == "[MUTED]" ]]; then
        ${dunstify} -a "changeVolume" -t ${toString timeout} -u low -i audio-volume-muted -h string:x-dunst-stack-tag:${tag} "Volume muted"
    else
        ${dunstify} -a "changeVolume" -t ${toString timeout} -u low -i audio-volume-high -h string:x-dunst-stack-tag:${tag} -h int:value:"$volume" "Volume: ''${volume}/100%"
    fi

    # Play the volume changed sound
    ${play} -i audio-volume-change -d "changeVolume"
  ''
