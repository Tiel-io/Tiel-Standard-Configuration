#!/usr/bin/env bash

## Use our Rofi password helper to ask for the sudo password.
export SUDO_ASKPASS=/usr/local/bin/rofi-ask-password.sh

## Execute the application; some applications require special logic for this.
if [[ "$1" == "atom" ]]; then
  sudo -A atom --no-sandbox
else
  sudo -A $1
fi
