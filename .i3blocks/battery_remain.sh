#!/bin/bash
AC=$(upower -i /org/freedesktop/UPower/devices/line_power_AC)
BAT0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
BAT1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)
DDEVICE=$(upower -i /org/freedesktop/UPower/devices/DisplayDevice)

AC_ONLINE=$(echo $AC | cut -d ' ' -f 26) # line-power -> online
PERC_REMAIN=$(echo $DDEVICE | cut -d ' ' -f 42)
TIME_REMAIN=$(echo $DDEVICE | cut -d ' ' -f 39-40)

echo "$TIME_REMAIN"
echo ""
if [ "$AC_ONLINE" = "yes" ]; then # adjust message
	echo "#00FF00"
elif [ "$AC_ONLINE" = "no" ]; then
	echo "#FF0000"
fi

