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

## Determine Unison periodic sync settings.
PERIODIC_SYNC_DESCRIPTION="On"
PERIODIC_SYNC_TOGGLE="true"
if [ "$PERIODIC_SYNC" = true ]; then
  PERIODIC_SYNC_DESCRIPTION="Off"
  PERIODIC_SYNC_TOGGLE="false"
fi

## Display the menu.
menuStart
    echo '<item label="Refresh Openbox"><action name="Restart"/></item>'
    menuItem "Update Tiel Standard" "termite -e ~/.tiel-standard/Tiel-Standard-Configuration/tiel-standard-bootstrapper.sh"
    menuSeparator
    menuItem "Sync Unison" "sync-unison.sh"
    menuItem "Toggle Periodic Sync: $PERIODIC_SYNC_DESCRIPTION" "toggle-periodic-sync-unison.sh $PERIODIC_SYNC_TOGGLE"
    menuSeparator
    menuItem "Change Wallpaper" "nitrogen-wallpaper-selector.sh"
    menuItem "Change Boot Theme" "rofi-select-theme.sh"
    menuItem "Toggle Random Wallpaper: $DESKTOP_DESCRIPTION" "set-tiel-standard-config.sh RANDOMIZE_DESKTOP $DESKTOP_TOGGLE"
    menuItem "Toggle Random Boot Theme: $BOOT_DESCRIPTION" "set-tiel-standard-config.sh RANDOMIZE_BOOT $BOOT_TOGGLE"
    menuSeparator
    menuItem "GPU Settings" "nvidia-settings"
    menuItem "Change Refresh Rate" "set-refresh-rate.sh"
    menuSeparator
    menuItem "Audio Settings" "pavucontrol"
    menuItem "Printer Settings" "firefox -new-tab 'localhost:631/admin'"
    menuItem "Other Settings" "xfce4-settings-manager"
    menuSeparator
    echo '<menu execute="ob-kb-pipemenu.sh" id="keybinds" label="Keybindings"/>'
menuEnd
exit 0
