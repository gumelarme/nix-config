#!/usr/bin/env bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolume"

# 1 second short notification
timeout=1000

# Change the volume using alsa(might differ if you use pulseaudio)
amixer set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(amixer get Master | tail -1 | awk '{print $5}' | sed 's/[^0-9]*//g')"
mute="$(amixer get Master | tail -1 | awk '{print $6}' | sed 's/[^a-z]*//g')"
if [[ $volume == 0 || "$mute" == "off" ]]; then
    # Show the sound muted notification
    dunstify -a "changeVolume" -t "$timeout" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:$msgTag "Volume muted" 
else
    # Show the volume notification
    dunstify -a "changeVolume" -t "$timeout" -u low -i audio-volume-high -h string:x-dunst-stack-tag:$msgTag \
    -h int:value:"$volume" "Volume: ${volume}/100%"
fi

# Play the volume changed sound
canberra-gtk-play -i audio-volume-change -d "changeVolume"

