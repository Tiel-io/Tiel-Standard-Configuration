#!/usr/bin/env bash

## Load the current Tiel Standard configuration.
readonly MAIN_CONF="$HOME/.config/tiel-standard/main.conf"
source $MAIN_CONF

## If we are not supposed to cycle wallpapers, simply lock.
if [ "$RANDOMIZE_DESKTOP" = false ]; then
  betterlockscreen -l blur & betterlockscreen -w

## Lock the screen, update the desktop background, and select a new lock image.
else
  betterlockscreen -l blur & betterlockscreen -w & betterlockscreen -u ~/Pictures/Wallpapers/
fi
