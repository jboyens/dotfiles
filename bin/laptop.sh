#!/usr/bin/env bash

if grep -q open /proc/acpi/button/lid/LID0/state; then
	if [ -n "$SWAYSOCK" ]; then
		swaymsg output eDP-1 enable
	fi

	if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
		hyprctl keyword monitor "eDP-1,preferred,0x0,1"
	fi
else
	if [ -n "$SWAYSOCK" ]; then
		swaymsg output eDP-1 disable
	fi

	if [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
		hyprctl keyword monitor "eDP-1,disable"
	fi
fi
