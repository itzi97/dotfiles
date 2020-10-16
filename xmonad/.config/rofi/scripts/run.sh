#!/usr/bin/env bash

rofi -show drun -dpi 192 -run-shell-command '{terminal} -e \\" {cmd}; read -n 1 -s\\"'
