#!/usr/bin/env bash

## This script downloads and runs the Tiel Standard installation script.
## @author Tim Clancy
## @date 8.17.2020

export SUDO_ASKPASS=/usr/local/bin/rofi-ask-password.sh
if [ ! -f $SUDO_ASKPASS ]; then
  sudo ls > /dev/null
else
  sudo -A ls > /dev/null
fi
mkdir ~/.tiel-standard
cd ~/.tiel-standard
wget -O tiel-standard-linux-installer.sh https://raw.githubusercontent.com/Tiel-io/Tiel-Standard-Configuration/master/tiel-standard-linux-installer.sh
sudo chmod +x tiel-standard-linux-installer.sh
./tiel-standard-linux-installer.sh true
sudo rm ~/.tiel-standard/tiel-standard-linux-installer.sh
