#!/usr/bin/env bash

## Use Rofi to prompt a user to enter a password with a provided prompt.
rofi -dmenu -password -i -no-fixed-num-lines -p "$1"\
    -theme "$HOME/.config/rofi/dialogs/askpass.rasi"
