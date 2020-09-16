#!/bin/sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
# while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch main bar
polybar -c ~/.config/polybar/polybar-4/config.ini main &

# Generate i3 Icon List
counter=0
i3-msg -t get_workspaces | tr ',' '\n' | sed -nr 's/"name":"([^"]+)"/\1/p' | while read -r name; do
	printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
done
