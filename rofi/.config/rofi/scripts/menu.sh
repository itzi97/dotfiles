#!/usr/bin/env bash

screen_name=$(xrandr | grep -w connected | awk -v OFS=' ' '{print $1}')

if [[ "${screen_name}" = "eDP1" ]]; then
  # HiDPI Screens
  rofi -combi-modi window,drun,ssh \
    -show combi \
    -theme "arthur" \
    -icon-theme "Papirus" \
    -show-icons -dpi 192
else
  # Normal DPI
  rofi -combi-modi window,drun,ssh \
    -show combi \
    -theme "arthur" \
    -icon-theme "Papirus" \
    -show-icons
fi
