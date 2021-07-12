#!/bin/sh

INT="eDP-1"
EXT="DP-2"

case "$1" in
    "disconnect") xrandr --output "$EXT" --off --output "$INT" --auto;;
    "extra") xrandr --output "$EXT" --set audio force-dvi --mode 1920x1080 --rate 60 && \
        xrandr --output "$INT" --auto --output "$EXT" --right-of "$INT" --scale 2x2 ;;
    "duplicate") xrandr --output "$EXT" --set audio force-dvi --mode 1920x1080 --rate 60 && \
        xrandr --output "$INT" --auto --output "$EXT" --same-as "$INT" ;;
        *) notify-send "Multi Monitor" "Unknown Operation";;
esac
