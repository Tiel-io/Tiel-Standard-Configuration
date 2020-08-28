#!/usr/bin/env bash

## Use Rofi to prompt a user to enter a refresh rate.
RATE=$(rofi -dmenu -i -no-fixed-num-lines -p "Refresh rate: "\
    -theme "$HOME/.config/rofi/dialogs/askpass.rasi")

## Then update the refresh rate of all screens.
RESOLUTION=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
SCREENS=$(xrandr | grep " connected " | awk '{ print$1 }')
for SCREEN in "${SCREENS[@]}"
do
   xrandr --output $SCREEN --mode $RESOLUTION --rate $RATE
done
