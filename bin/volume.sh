#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

function get_volume {
    #sinkName=$(pacmd info | awk '/Default sink/ {print $4}')
    #sinkNumber=$(pacmd info | grep "sink:.*$sinkName" | awk '{print $2}')
    #volumeInput=$(pactl list sinks)
    #echo "${volumeInput#*Sink #$sinkNumber}" | grep -E 'V.*-left' | grep -oE '[0-9]+%' | tail -n 1
    pactl list sinks | awk '/Volume/ {print $5; exit}' | cut -d'%' -f1
}

function is_muted {
    pactl list sinks | grep 'Mute: yes'
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Send the notification
    if is_muted ; then
        msg="(muted) $volume $bar"
    else
        msg="$volume    $bar"
    fi
    dunstify -i audio-volume-muted-blocking -t 2000 -r 2593 -u normal $msg
}

case "$1" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%;
        send_notification
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%;
        send_notification
        ;;
    mute)
        if is_muted ; then
            pactl set-sink-mute @DEFAULT_SINK@ 0
            send_notification
        else
            pactl set-sink-mute @DEFAULT_SINK@ 1
            send_notification
        fi
        ;;
    list)
        send_notification
        ;;
esac

