#!/usr/bin/env bash

rofi -show run -dpi 192 -run-shell-command '{terminal} -e \\" {cmd}; read -n 1 -s\\"'
