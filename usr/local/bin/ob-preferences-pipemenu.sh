#!/usr/bin/env bash

## Load the current Tiel Standard configuration.
readonly MAIN_CONF="$HOME/.config/tiel-standard/main.conf"
source $MAIN_CONF

## Include required ArchLabs configuration.
if ! . "/usr/lib/archlabs/common/al-include.cfg" 2> /dev/null; then
  echo $"Error: Failed to locate /usr/lib/archlabs/common//al-include.cfg" >&2
  exit 1
fi

## Determine desktop and boot theme randomization settings.
DESKTOP_DESCRIPTION="On"
DESKTOP_TOGGLE="true"
if [ "$RANDOMIZE_DESKTOP" = true ]; then
  DESKTOP_DESCRIPTION="Off"
  DESKTOP_TOGGLE="false"
fi
BOOT_DESCRIPTION="On"
BOOT_TOGGLE="true"
if [ "$RANDOMIZE_BOOT" = true ]; then
  BOOT_DESCRIPTION="Off"
  BOOT_TOGGLE="false"
fi

## Display the menu.
menuStart
    echo '<item label="Refresh Openbox"><action name="Restart"/></item>'
    menuItem "Update Tiel Standard" "termite -e '~/.tiel-standard/Tiel-Standard-Configuration/tiel-standard-bootstrapper.sh'"
    menuSeparator
    menuItem "Change Wallpaper" "nitrogen-wallpaper-selector.sh"
    menuItem "Change Boot Theme" "rofi-select-theme.sh"
    menuItem "Toggle Random Wallpaper: $DESKTOP_DESCRIPTION" "set-tiel-standard-config.sh RANDOMIZE_DESKTOP $DESKTOP_TOGGLE"
    menuItem "Toggle Random Boot Theme: $BOOT_DESCRIPTION" "set-tiel-standard-config.sh RANDOMIZE_BOOT $BOOT_TOGGLE"
    menuSeparator
    menuItem "Power Settings" "xfce4-power-manager-settings"
    menuItem "Audio Settings" "pavucontrol"
    menuItem "Other Settings" "xfce4-settings-manager"
menuEnd
exit 0
