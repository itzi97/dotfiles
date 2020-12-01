#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# style_1     style_2     style_3     style_4     style_5     style_6
# style_7     style_8     style_9     style_10    style_11    style_12

theme="style_1"
dir="$HOME/.config/rofi/launchers/colorful"

# dark
ALPHA="#00000000"
BG="#212B3000"
FG="#C4C7C5ff"
SELECT="#101010ff"

# light
#ALPHA="#00000000"
#BG="#FFFFFFff"
#FG="#000000ff"
#SELECT="#f3f3f3ff"

# accent colors
COLORS=[]
COLORS[0]='#EC7875'
COLORS[1]='#61C766'
COLORS[2]='#FDD835'
COLORS[3]='#42A5F5'
COLORS[4]='#BA68C8'
COLORS[5]='#4DD0E1'
COLORS[6]='#00B19F'
COLORS[7]='#FBC02D'
COLORS[8]='#E57C46'
COLORS[9]='#AC8476'
COLORS[10]='#6D8895'
COLORS[11]='#EC407A'
COLORS[12]='#B9C244'
COLORS[13]='#6C77BB'
ACCENT="${COLORS[10]}ff"

# overwrite colors file
cat > $dir/colors.rasi <<- EOF
	/* colors */

	* {
	  al:  $ALPHA;
	  bg:  $BG;
	  se:  $SELECT;
	  fg:  $FG;
	  ac:  $ACCENT;
	}
EOF

# comment these lines to disable random style
themes=($(ls -p --hide="launcher.sh" --hide="colors.rasi" $dir))
theme="${themes[0]}"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
