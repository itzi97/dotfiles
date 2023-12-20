#!/usr/bin/env bash

# Initializing wallpaper daemon
swww init &
# Setting wallpaper
swww img ~/.wallpaper.png &

# You can install this by adding
# pkgs.networkmanagerapplet to your packages
nm-applet --indicator &

# The bar
waybar &

# Dunst
dunst
