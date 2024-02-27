#!/usr/bin/env bash
# changeBrightness

# Arbitrary but unique message tag
msgTag="myBrightness"

# 1 second short notification
timeout=1000

# Change the brightness using alsa(might differ if you use pulseaudio)
xbacklight "$@" > /dev/null

# Query amixer for the current brightness and whether or not the speaker is muted
brightness=$(xbacklight -get)
# Show the brightness notification
dunstify -a "changeBrightness" -t "$timeout" -u low -i display-brightness -h string:x-dunst-stack-tag:$msgTag \
-h int:value:"$brightness" "Brightness: ${brightness}/100"

# Play the brightness changed sound
canberra-gtk-play -i audio-volume-change -d "changeBrightness"
