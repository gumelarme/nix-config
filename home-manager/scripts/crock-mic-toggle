#!/usr/bin/env bash

# Arbitrary but unique message tag
msgTag="myMic"

# 1 second short notification
timeout=1000

# Change the mic_status using alsa(might differ if you use pulseaudio)
amixer set Capture toggle > /dev/null

# Query amixer for the current mic_status and whether or not the speaker is muted
mic_status=$(amixer get Capture | tail -1 | awk '{print $6}' | sed 's/[^a-z]//g' | sed 's/./\U&/')
# Show the mic_status notification
dunstify -a "changeMic" -t "$timeout" -u low -i audio-input-microphone -h string:x-dunst-stack-tag:$msgTag "Mic: ${mic_status}"

# Play the mic_status changed sound
canberra-gtk-play -i audio-volume-change -d "changeMic"
