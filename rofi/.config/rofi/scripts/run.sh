#!/usr/bin/env bash


screen_name=$(xrandr | grep -w connected | awk -v OFS=' ' '{print $1}')

if [[ "${screen_name}" = "eDP1" ]]; then
  # HiDPI Screens
  rofi -show run -dpi 192 \
    -run-shell-command '{terminal} -e \\" {cmd}; read -n 1 -s\\"'
else
  # Normal DPI
  rofi -show run -run-shell-command '{terminal} -e \\" {cmd}; read -n 1 -s\\"'
fi
