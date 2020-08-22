#!/usr/bin/env bash

## Randomly find the name of a particular directory in our themes repository.
THEME_NAME=$(ls -F ~/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/ | grep / | shuf -n 1 | rev | cut -c2- | rev)
cp -r ~/.tiel-standard/Tiel-Standard-Configuration/Curated-Plymouth-Themes/$THEME_NAME /usr/share/plymouth/themes/
plymouth-set-default-theme -R $THEME_NAME
