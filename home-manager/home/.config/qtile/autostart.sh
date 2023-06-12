#! /usr/bin/sh
# swap escape and caps lock
setxkbmap -option caps:swapescape

# Wallpaper
# feh --bg-scale /home/gumendol/Pictures/wallpaper/ghibli-lizard.jpg



# compositor, transparency
picom -b &

#
fcitx5-remote &

dunst &

flameshot &

redshift-gtk &

source /home/gumendol/.xprofile


# Multi monitor
arandr ~/.config/screenlayout/stack-swap-primary.sh > ~/arandrout
# xrandr --output eDP-1 --mode 1920x1080 --pos 320x1440 --rotate normal --output HDMI-1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off
