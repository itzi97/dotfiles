#!/usr/bin/env bash
#
#  i3-volume
#
#  Volume control and volume notifications for i3wm.
#
#  Requires:
#    alsa-utils or pulseaudio-utils
#    awk (POSIX compatible)
#
#  Optional:
#    A libnotify compatible notification daemon such as notify-osd or dunst
#    notify-send (libnotify) or dunstify (dunst)
#
#  Copyright (c) 2016 Beau Hastings. All rights reserved.
#  License: GNU General Public License v2
#
#  Author: Beau Hastings <beau@saweet.net>
#  URL: https://github.com/hastinbe/i3-volume

# Get default sink name
get_default_sink_name() {
	pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}

# Get the volume as a percentage.
get_volume() {
	if $opt_use_amixer; then
		get_volume_amixer $card
	else
		get_volume_pulseaudio $sink
	fi
}

# Get the volume as a percentage.
#
# Arguments
#   Sink name   (string) Symbolic name of sink.
get_volume_pulseaudio() {
	local sink="$1"

	pacmd list-sinks |
		awk -W posix '/^[ \t]+name: /{insink = $2 == "<'$sink'>"}
      /^[ \t]+volume: / && insink {gsub("%", ""); print $5; exit}'
}

# Get the volume as a percentage.
#
# Arguments
#   Card        (integer) Card number to control.
get_volume_amixer() {
	local card="$1"
	local volume

	if [ -n "$card" ]; then
		volume=$(amixer -c "$card" -- sget Master)
	else
		volume=$(amixer sget Master)
	fi

	echo $volume | awk -W posix -F'[][]' '/dB/ { gsub("%", ""); print $2 }'
}

# Increase volume relative to current volume.
#
# Arguments:
#   Step        (integer) Percentage to increase by.
raise_volume() {
	if $opt_use_amixer; then
		raise_volume_amixer "$card" "$1"
	else
		raise_volume_pulseaudio "$sink" "$1"
	fi
}

# Increase volume relative to current volume using pulseaudio.
#
# Arguments:
#   Sink name   (string)  Symbolic name of sink.
#   Step        (integer) Percentage to increase by.
raise_volume_pulseaudio() {
	local sink="$1"
	local step="${2:-5}"

	set_volume_pulseaudio "$sink" "+${step}%"
}

# Increase volume relative to current volume using amixer.
#
# Arguments:
#   Card        (integer) Card number to control.
#   Step        (integer) Percentage to increase by.
raise_volume_amixer() {
	local card="$1"
	local step="${2:-5}"

	set_volume_amixer "$card" "${step}%+"
}

# Decrease volume relative to current volume.
#
# Arguments:
#   Step        (integer) Percentage to decrease by.
lower_volume() {
	if $opt_use_amixer; then
		lower_volume_amixer "$card" "$1"
	else
		lower_volume_pulseaudio "$sink" "$1"
	fi
}

# Decrease volume relative to current volume using pulseaudio.
#
# Arguments:
#   Sink name   (string)  Symbolic name of sink.
#   Step        (integer) Percentage to decrease by.
lower_volume_pulseaudio() {
	local sink="$1"
	local step="${2:-5}"

	set_volume_pulseaudio "$sink" "-${step}%"
}

# Decrease volume relative to current volume using amixer.
#
# Arguments:
#   Card        (integer) Card number to control.
#   Step        (integer) Percentage to decrease by.
lower_volume_amixer() {
	local card="$1"
	local step="${2:-5}"

	set_volume_amixer "$card" "${step}%-"
}

# Set volume.
#
# Arguments:
#   Step        (integer) Percentage to decrease by.
set_volume() {
	if $opt_use_amixer; then
		set_volume_amixer "$card" "$1"
	else
		set_volume_pulseaudio "$sink" "$1"
	fi
}

# Set volume using pulseaudio.
#
# Arguments:
#   Sink name   (string) Symbolic name of sink.
#   Volume      (integer|linear factor|percentage|decibel)
set_volume_pulseaudio() {
	local sink="$1"
	local vol="$2"

	pactl set-sink-volume "$sink" "$vol" || pactl set-sink-volume "$sink" -- "$vol"
}

# Set volume using amixer.
#
# Arguments:
#   Card        (integer) Card number to control.
#   Volume      (integer|linear factor|percentage|decibel)
set_volume_amixer() {
	local card="$1"
	local vol="$2"

	if [ -n "$card" ]; then
		amixer -q -c "$card" -- set Master "$vol"
	else
		amixer -q set Master "$vol"
	fi
}

# Toggle mute.
toggle_mute() {
	if $opt_use_amixer; then
		toggle_mute_amixer "$card"
	else
		toggle_mute_pulseaudio "$sink"
	fi
}

# Toggle mute using pulseaudio.
#
# Arguments:
#   Sink name   (string) Symbolic name of sink.
toggle_mute_pulseaudio() {
	local sink="$1"

	pactl set-sink-mute "$sink" toggle
}

# Toggle mute using amixer.
#
# Arguments:
#   Card        (integer) Card number to control.
toggle_mute_amixer() {
	local card="$1"

	if [ -n "$card" ]; then
		amixer -q -c "$card" -- set Master toggle
	else
		amixer -q set Master toggle
	fi
}

# Check if muted.
is_muted() {
	if $opt_use_amixer; then
		return $(is_muted_amixer "$card")
	else
		return $(is_muted_pulseaudio "$sink")
	fi
}

# Check if sink is muted.
#
# Arguments:
#   Sink name    (string) Symbolic name of sink.
#
# Returns:
#   0 when true, 1 when false.
is_muted_pulseaudio() {
	local sink="$1"

	muted=$(pacmd list-sinks |
		awk -W posix '/^[ \t]+name: /{insink = $2 == "<'$sink'>"}
      /^[ \t]+muted: / && insink {print $2; exit}')
	[ "$muted" = "yes" ]
}

# Check if card is muted.
#
# Arguments:
#   Card        (integer) Card number to control.
#
# Returns:
#   0 when true, 1 when false.
is_muted_amixer() {
	local card="$1"
	local output

	if [ -n "$card" ]; then
		output=$(amixer -c "$card" -- sget Master)
	else
		output=$(amixer sget Master)
	fi

	status=$(echo $output | awk -W posix -F'[][]' '/dB/ { print $6 }')

	[ "$status" = "off" ]
}

# Gets an icon for the provided volume.
#
# Arguments:
#   Volume      (integer) An integer indicating the volume.
#
# Returns:
#   The volume icon name.
get_volume_icon() {
	local vol="$1"
	local icon

	if $opt_use_legacy_icons; then
		if [ "$vol" -ge 70 ]; then
			icon="notification-audio-volume-high"
		elif [ "$vol" -ge 40 ]; then
			icon="notification-audio-volume-medium"
		elif [ "$vol" -gt 0 ]; then
			icon="notification-audio-volume-low"
		else
			icon="notification-audio-volume-off"
		fi
	else
		if [ "$vol" -gt 100 ]; then
			icon="audio-volume-overamplified-symbolic.symbolic"
		elif [ "$vol" -ge 70 ]; then
			icon="audio-volume-high-symbolic.symbolic"
		elif [ "$vol" -ge 40 ]; then
			icon="audio-volume-medium-symbolic.symbolic"
		elif [ "$vol" -gt 0 ]; then
			icon="audio-volume-low-symbolic.symbolic"
		else
			icon="audio-volume-low-symbolic.symbolic"
		fi
	fi

	echo "${icon}"
}

# Display a notification indicating the volume is muted.
notify_muted() {
	local icon

	if $opt_use_legacy_icons; then
		icon="notification-audio-volume-muted"
	else
		icon="audio-volume-muted-symbolic.symbolic"
	fi

	if $opt_use_dunstify; then
		dunstify -i $icon -t $expires -h int:value:0 -h string:synchronous:volume "Volume muted" -r 1000
	else
		notify-send -i $icon -t $expires -h int:value:0 -h string:synchronous:volume "Volume muted"
	fi
}

# Display a notification indicating the current volume.
notify_volume() {
	local vol=$(get_volume)
	local icon=$(get_volume_icon "$vol")
	local text="${vol}%"

	if $opt_show_volume_progress; then
		local progress=$(get_progress_bar "$vol")
		text="${text} ${progress}"
	fi

	text="Volume ${text}"

	if $opt_use_dunstify; then
		dunstify -i "$icon" -t $expires -h int:value:"$vol" -h string:synchronous:volume "$text" -r 1000
	else
		notify-send -i "$icon" -t $expires -h int:value:"$vol" -h string:synchronous:volume "$text"
	fi

	# Play the volume changed sound
	canberra-gtk-play -i audio-volume-change -d "changeVolume"

}

# Updates the status line.
#
# Arguments:
#   signal  (string) The signal used to update the status line.
#   proc    (string) The name of the status line process.
update_statusline() {
	local signal="$1"
	local proc="$2"
	pkill "-$signal" "$proc"
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
	local percent="$1"
	local max_percent=${2:-100}
	local divisor=${3:-5}
	local progress=$((($percent > $max_percent ? $max_percent : $percent) / $divisor))

	if [ "$progress" -ge 1 ]; then
		printf '─%.0s' $(eval echo "{1..$progress}")
	else
		echo ""
	fi
}

# Display program usage.
usage() {
	echo "Usage: $0 [options]
	Control volume and related notifications.

	Options:
  -a                use alsa-utils instead of pulseaudio-utils for volume control
  -c <card>         card number to control (amixer only)
  -d <amount>       decrease volume
  -e <expires>      expiration time of notifications, in milliseconds
  -i <amount>       increase volume
  -l                use legacy icons
  -m                toggle mute
  -n                show notifications
  -p                show text volume progress bar
  -s <sink_name>    symbolic name of sink (pulseaudio only)
  -t <process_name> name of status line process. must be used with -u
  -u <signal>       update status line using signal. must be used with -t
  -v <value>        set volume
  -y                use dunstify instead of notify-send
  -h                display this help and exit
	" 1>&2
	exit 1
}
###########################################################

opt_decrease_volume=false
opt_increase_volume=false
opt_mute_volume=false
opt_notification=false
opt_set_volume=false
opt_show_volume_progress=false
opt_use_amixer=false
opt_use_dunstify=false
opt_use_legacy_icons=false
card=""
signal=""
sink=""
statusline=""
volume=5
expires="1500"

while getopts ":ac:d:e:hi:lmnps:t:u:v:y" o; do
	case "$o" in
	a)
		opt_use_amixer=true
		;;
	c)
		card="${OPTARG}"
		;;
	d)
		opt_decrease_volume=true
		volume="${OPTARG}"
		;;
	e)
		expires="${OPTARG}"
		;;
	i)
		opt_increase_volume=true
		volume="${OPTARG}"
		;;
	l)
		opt_use_legacy_icons=true
		;;
	m)
		opt_mute_volume=true
		;;
	n)
		opt_notification=true
		;;
	p)
		opt_show_volume_progress=true
		;;
	s)
		sink="${OPTARG}"
		;;
	t)
		statusline="${OPTARG}"
		;;
	u)
		signal="${OPTARG}"
		;;
	v)
		opt_set_volume=true
		volume="${OPTARG}"
		;;
	y)
		opt_use_dunstify=true
		;;
	h | *)
		usage
		;;
	esac
done
shift $((OPTIND - 1)) # Shift off options and optional --

if ! $opt_use_amixer; then
	if [ -z $sink ]; then
		sink="$(get_default_sink_name)"
	fi
fi

if ${opt_increase_volume}; then
	raise_volume $volume
fi

if ${opt_decrease_volume}; then
	lower_volume $volume
fi

if ${opt_set_volume}; then
	set_volume $volume
fi

if ${opt_mute_volume}; then
	toggle_mute $sink
fi

# The options below this line must be last
if ${opt_notification}; then
	if is_muted; then
		notify_muted
	else
		notify_volume
	fi
fi

if [ -n "${signal}" ]; then
	if [ -z "${statusline}" ]; then
		usage
	fi
	update_statusline "${signal}" "${statusline}"
else
	if [ -n "${statusline}" ]; then
		usage
	fi
fi
