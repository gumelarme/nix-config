#!/usr/bin/env bash

# TODO: pick primary screen using better method

screen_count=$(xrandr --listmonitors | head -1 | sed 's/[^0-9]//g')
screen=$((screen_count - 1))

eww open \
    --screen $screen \
    --toggle \
    media-control
