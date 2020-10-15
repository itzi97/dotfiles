#!/usr/bin/env bash
#
#  i3-kb-backlight
#
#  Keyboard backlight control and notifications for i3wm
#
#  Requires:
#    awk (POSIX compatible)
#    bc
#    upower
#
#  Optional:
#    A libnotify compatible notification daemon such as notify-osd or dunst
#    notify-send (libnotify) or dunstify (dunst)
#
#  Copyright (c) 2018 Beau Hastings. All rights reserved.
#  License: GNU General Public License v2
#
#  Author: Beau Hastings <beau@saweet.net>
#  URL: https://github.com/hastinbe/i3-kb-brightness

get_brightness() {
	local value=$(xbacklight -get)
	echo "${value%.*}"
}

increase_brightness() {
	local step="$1"
	xbacklight -inc "${step%.*}"
}

decrease_brightness() {
	local step="$1"
	xbacklight -dec "${step%.*}"
}

get_brightness_icon() {
	local brightness="$1"
	local icon

	if [ "$brightness" -ge 100 ]; then
		icon="notification-display-brightness-full"
	elif [ "$brightness" -ge 70 ]; then
		icon="notification-display-brightness-high"
	elif [ "$brightness" -ge 40 ]; then
		icon="notification-display-brightness-medium"
	elif [ "$brightness" -gt 0 ]; then
		icon="notification-display-brightness-low"
	else
		icon="notification-display-brightness-off"
	fi

	echo "${icon}"
}

# Generates a progress bar for the provided value.
#
# Arguments:
#   Percentage      (integer) Percentage of progress.
#   Maximum         (integer) Maximum percentage. (default: 100)
#   Divisor         (integer) For calculating the ratio of blocks to progress (default: 5)
#
# Returns:
#   The progress bar.
get_progress_bar() {
	local percent="${1%.*}"
	local max_percent=${2:-100}
	local divisor=${3:-5}
	local progress=$((($percent > $max_percent ? $max_percent : $percent) / $divisor))

	if [ "$progress" -ge 1 ]; then
		printf '─%.0s' $(eval echo "{1..$progress}")
	else
		echo ""
	fi
}

notify_brightness() {
	local max=100
	local brightness=$(get_brightness)
	local percent=$(echo "scale=2; $brightness / $max * 100" | bc -l)
	local text="${percent%.*}%"
	local icon=$(get_brightness_icon "$brightness")

	if $opt_show_progress_bar; then
		local progress=$(get_progress_bar "$percent" 100 5)
		text="$text $progress"
	fi

	if $opt_use_dunstify; then
		dunstify -i $icon -t $expires -h int:value:"$percent" -h string:synchronous:brightness "$text" -r 3412
	else
		notify-send -i $icon -t $expires -h int:value:"$percent" -h string:synchronous:brightness "$text"
	fi
}

usage() {
	echo "Usage: $0 [options]
	Control keyboard backlight brightness.

	Options:
  -d <amount>       decrease brightness
  -i <amount>       increase brightness
  -e <expires>      expiration time of notifications, in milliseconds
  -n                show notifications
  -p                show a text progress bar
  -y                use dunstify
  -h                display this help and exit
	" 1>&2
	exit 1
}

###########################################################

opt_show_progress_bar=false
opt_notification=false
opt_use_dunstify=false
expires="1500"

while getopts "d:i:npyh" o; do
	case "$o" in
	d) decrease_brightness $OPTARG ;;
	i) increase_brightness $OPTARG ;;
	e) expires=$OPTARG ;;
	n) opt_notification=true ;;
	p) opt_show_progress_bar=true ;;
	y) opt_use_dunstify=true ;;
	h | *) usage ;;
	esac
done
shift $((OPTIND - 1)) # Shift off options and optional --

if $opt_notification; then
	notify_brightness
fi
