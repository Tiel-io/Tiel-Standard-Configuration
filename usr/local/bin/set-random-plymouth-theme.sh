#!/usr/bin/env bash

## Randomly find the name of a particular directory in our themes repository.
USER_NAME=$(ls /home -1 | shuf -n1)
THEME_NAME=$(ls -F /home/$USER_NAME/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/ | grep / | shuf -n 1 | rev | cut -c2- | rev)
cp -r /home/$USER_NAME/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/$THEME_NAME /usr/share/plymouth/themes/
plymouth-set-default-theme -R $THEME_NAME || true
