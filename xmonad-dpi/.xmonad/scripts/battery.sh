#!/bin/bash

BATTINFO=`acpi -b`
if [[ `echo $BATTINFO | grep Discharging` && `echo $BATTINFO | cut -f 5 -d " "` < 00:15:00 ]] ; then
    DISPLAY=:0.0 dunstify "low battery" "$BATTINFO"
else
    DISPLAY=:0.0 dunstify "not low battery" "$BATTINFO"
fi
