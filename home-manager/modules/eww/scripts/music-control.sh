#!/usr/bin/env bash

## Get data
STATUS="$(mpc status | grep "\[.*\]" | awk '{print $1}' | sed 's/[^a-z]//g')"
COVER="/tmp/.music_cover.jpg"
MUSIC_DIR="$HOME/musics"

urldecode(){
    python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))" $@
}

## Get status
get_status() {
    echo $STATUS
}

## Get song
get_song() {
    song="$(mpc -f %title% current)"
    if [[ -z "$song" ]]; then
        echo "/off/"
    else
        echo "$song"
    fi
}

## Get artist
get_artist() {
    artist=`mpc -f %artist% current`
    if [[ -z "$artist" ]]; then
        echo "/off/"
    else
        echo "$artist"
    fi
}

## Get time
get_time() {
    time=`mpc status | grep "%)" | awk '{print $4}' | tr -d '(%)'`
    if [[ -z "$time" ]]; then
        echo "0"
    else
        echo "$time"
    fi
}
get_ctime() {
    ctime=`mpc status | grep "#" | awk '{print $3}' | sed 's|/.*||g'`
    if [[ -z "$ctime" ]]; then
        echo "0:00"
    else
        echo "$ctime"
    fi
}
get_ttime() {
    ttime=`mpc -f %time% current`
    if [[ -z "$ttime" ]]; then
        echo "0:00"
    else
        echo "$ttime"
    fi
}

## Get cover
get_cover() {
    file=$(mpc current -f %file% | head -1 | sed 's/.*://g')
    file=$(urldecode $file)

    ffmpeg -i "${MUSIC_DIR}/${file}" -an -vcodec copy -y "${COVER}" &> /dev/null
    STATUS=$?

    # Check if the file has a embbeded album art
    if [ "$STATUS" -eq 0 ];then
        echo "$COVER"
    else
        echo "images/music.jpg"
    fi
}

## Execute accordingly
if [[ "$1" == "--song" ]]; then
    get_song
elif [[ "$1" == "--artist" ]]; then
    get_artist
elif [[ "$1" == "--status" ]]; then
    get_status
elif [[ "$1" == "--time" ]]; then
    get_time
elif [[ "$1" == "--ctime" ]]; then
    get_ctime
elif [[ "$1" == "--ttime" ]]; then
    get_ttime
elif [[ "$1" == "--cover" ]]; then
    get_cover
elif [[ "$1" == "--toggle" ]]; then
    mpc -q toggle
elif [[ "$1" == "--next" ]]; then
    { mpc -q next; get_cover; }
elif [[ "$1" == "--prev" ]]; then
    { mpc -q prev; get_cover; }
fi
