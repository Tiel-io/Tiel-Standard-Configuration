#!/usr/bin/env bash

## This script downloads and runs the Tiel Standard installation script.
## @author Tim Clancy
## @date 8.17.2020

mkdir ~/.tiel-standard
mkdir ~/.tiel-standard/Tiel-Standard-Configuration
cd ~/.tiel-standard/Tiel-Standard-Configuration
wget -O tiel-standard-linux-installer.sh https://raw.githubusercontent.com/Tiel-io/Tiel-Standard-Configuration/master/tiel-standard-linux-installer.sh
sudo chmod +x tiel-standard-linux-installer.sh
./tiel-standard-linux-installer.sh true
