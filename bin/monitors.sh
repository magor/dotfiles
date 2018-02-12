#!/bin/sh

case "$1" in
    nb-only)
        xrandr --output eDP-1 --auto --primary \
            --output DP-1-1 --off \
            --output DP-1-2 --off
        ;;
    desktop)
        xrandr --output DP-1-2 --auto --primary \
            --output DP-1-1 --auto --rotate left --right-of DP-1-2 \
            --output eDP-1 --auto --left-of DP-1-2
        ;;
esac

