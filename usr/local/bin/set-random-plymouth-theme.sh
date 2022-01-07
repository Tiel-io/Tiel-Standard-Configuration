#!/usr/bin/env bash

## This is a dirty hack to find the user; this will only work with one user.
USER_NAME=$(ls /home -1 | shuf -n1)

## If we are not supposed to cycle Plymouth themes, exit early.
source /home/$USER_NAME/.config/tiel-standard/main.conf
if [ "$RANDOMIZE_BOOT" = false ]; then
  exit 0
fi

## Randomly find the name of a particular directory in our themes repository.
THEME_NAME=$(ls -F /home/$USER_NAME/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/ | grep / | shuf -n 1 | rev | cut -c2- | rev)
cp -r /home/$USER_NAME/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/$THEME_NAME /usr/share/plymouth/themes/
plymouth-set-default-theme -R $THEME_NAME || true
