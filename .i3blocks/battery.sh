#!/bin/bash
AC=$(upower -i /org/freedesktop/UPower/devices/line_power_AC)
BAT0=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0)
BAT1=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1)
DDEVICE=$(upower -i /org/freedesktop/UPower/devices/DisplayDevice)

AC_ONLINE=$(echo $AC | cut -d ' ' -f 26) # line-power -> online
PERC_REMAIN=$(echo $DDEVICE | cut -d ' ' -f 42 | cut -d "%" -f 1 | cut -d "," -f 1)
TIME_REMAIN=$(echo $DDEVICE | cut -d ' ' -f 39)
TIME_UNIT=$(echo $DDEVICE | cut -d ' ' -f 40)
TIME_UNIT=$(echo ${TIME_UNIT:0:1})

X=$PERC_REMAIN
PERC_REMAIN="$PERC_REMAIN%"
PERC_WEIGHT="normal"
PERC_UNDERLINE="none"

if ((0<=X && X<=20)); then
	PERC_COLOR="#fc0000"
	BLINK=$(expr $(date +"%s") % 2)
	if [ "$BLINK" = "0" ]; then
		PERC_REMAIN="low"
		PERC_WEIGHT="heavy"
		PERC_UNDERLINE="single"
	elif [ "$BLINK" = "1" ]; then
		PERC_WEIGHT="normal"
		PERC_UNDERLINE="none"
	fi
elif ((20<=X && X<=70)); then
	PERC_COLOR="#adad00"
elif ((70<=X && X<=100)); then
	PERC_COLOR="#0bad00"
fi


if [ "$AC_ONLINE" = "yes" ]; then # adjust message
	COLOR_TIME="#0bad00"
	dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness int32:0 > /dev/null
elif [ "$AC_ONLINE" = "no" ]; then
	COLOR_TIME="#fc0000"
	KBD_BLINK=$(expr $(date +"%s") % 5)
	if ((0<=X && X<=20)); then
		if [ "$KBD_BLINK" = "0" ]; then
			dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness int32:2 > /dev/null
		elif [ "$KBD_BLINK" = "4" ]; then
			dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower/KbdBacklight org.freedesktop.UPower.KbdBacklight.SetBrightness int32:0 > /dev/null
		fi
	fi
fi

echo "<span foreground=\"$PERC_COLOR\" underline=\"$PERC_UNDERLINE\" font_weight=\"$PERC_WEIGHT\">$PERC_REMAIN</span><sup><span foreground=\"$COLOR_TIME\"> $TIME_REMAIN $TIME_UNIT</span></sup>"
