#!/usr/bin/env bash

## Run Nitrogen to let the user select a wallpaper, then update the lock screen.
nitrogen ~/Pictures/Wallpapers
readonly NITROGEN_CONF="$HOME/.config/nitrogen/bg-saved.cfg"
DESKTOP_BACKGROUND=$(sed -n '2p' $NITROGEN_CONF)
DESKTOP_BACKGROUND=${DESKTOP_BACKGROUND:5}
betterlockscreen -u $DESKTOP_BACKGROUND
