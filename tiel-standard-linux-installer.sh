#!/usr/bin/env bash

## This script installs and configures a standard experience over the top of the
## Archcraft OS distributed by Aditya Shakya.
## @author Tim Clancy
## @date 8.21.2020

## Immediately prompt for administrator permissions.
## Use our Rofi password helper to ask for the sudo password if it is present.
export SUDO_ASKPASS=/usr/local/bin/rofi-ask-password.sh
echo "--- Prompting for administrator permission. ---"
if [ ! -f $SUDO_ASKPASS ]; then
  sudo ls > /dev/null
else
  sudo -A ls > /dev/null
fi
echo "--- Permission received. ---"
echo ""

## Create and populate the Tiel standard data folder.
echo "--- Preparing Tiel Standard installation files. ---"
tiel_dir="${HOME}/.tiel-standard"
first_time=false
MADE_TIEL_DIR=false
if [ ! -d "${tiel_dir}" ]; then
  echo "* creating Tiel Standard directory: mkdir -p $tiel_dir"
  mkdir -p "${tiel_dir}"
  first_time=true
  MADE_TIEL_DIR=true
else
  echo "* found existing Tiel Standard directory: $tiel_dir"
  first_time=$1
fi

## Create the Tiel standard configuration file.
TIEL_CONFIG="${HOME}/.config/tiel-standard"
if [ ! -d "${TIEL_CONFIG}" ]; then
  echo "* creating Tiel Standard configuration directory: mkdir -p $TIEL_CONFIG"
  mkdir -p "${TIEL_CONFIG}"
  touch "$TIEL_CONFIG/main.conf"
  echo "RANDOMIZE_DESKTOP=true" >> "$TIEL_CONFIG/main.conf"
  echo "RANDOMIZE_BOOT=true" >> "$TIEL_CONFIG/main.conf"
else
  echo "* found existing Tiel Standard configuration directory: $TIEL_CONFIG"
fi

## Pull the most recent standard configuration.
cd "${tiel_dir}"
echo "* getting most up-to-date standard configuration content"
if [ "$first_time" = true ]; then
  git clone https://github.com/Tiel-io/Tiel-Standard-Configuration.git
fi
cd Tiel-Standard-Configuration
git fetch --all
git reset --hard origin/master
if [ "$first_time" = true ]; then
  git clone https://github.com/TimTinkers/rofi-iwd-menu.git
fi
cd rofi-iwd-menu
git fetch --all
git reset --hard origin/master
cd ../
if [ "$first_time" = true ]; then
  git clone https://github.com/TimTinkers/Reddit-Wallpaper-Downloader.git
fi
cd Reddit-Wallpaper-Downloader
git fetch --all
git reset --hard origin/master
cd ../
if [ "$first_time" = true ]; then
  git clone https://github.com/TimTinkers/Curated-Plymouth-Themes.git
fi
cd Curated-Plymouth-Themes
git fetch --all
git reset --hard origin/master
cd ../

## Move scripts to the user's bin for easy execution, and make them executable.
echo "* updating all user scripts"
sudo cp ./Curated-Plymouth-Themes/rofi-select-theme.sh /usr/local/bin/rofi-select-theme.sh
sudo cp ./rofi-iwd-menu/rofi-wifi-menu.sh /usr/local/bin/rofi-wifi-menu.sh
sudo cp ./Reddit-Wallpaper-Downloader/get-wallpapers.sh /usr/local/bin/get-wallpapers.sh
sudo cp -a ./Reddit-Wallpaper-Downloader/wallpaper-downloader/. /usr/local/bin/wallpaper-downloader/
sudo cp -a ./usr/local/bin/. /usr/local/bin/
find /usr/local/bin/ -type f -iname "*.sh" -exec sudo chmod +x {} \;

## Copy configuration files to the user's configuration directory.
echo "* updating all user configurations"
sudo cp -a ./.config/. ~/.config/

## Copy the provided iwd configuration file to where it belongs.
echo "* updating iwd main.conf file with network configuration settings"
mkdir /etc/iwd
sudo cp ./etc/iwd/main.conf /etc/iwd/main.conf

## Copy the provided gpg configuration file to where it belongs.
echo "* updating gpg.conf file with preferred keyserver settings"
mkdir ~/.gnupg
sudo cp ./.gnupg/gpg.conf ~/.gnupg/gpg.conf

## Copy the provided pacman gpg file to where it belongs.
echo "* updating pacman gpg.conf file with preferred keyserver settings"
sudo cp ./etc/pacman.d/gnupg/gpg.conf /etc/pacman.d/gnupg/gpg.conf
echo "--- Tiel Standard installation files are prepared. ---"
echo ""

## Install the Arch Linux keyring.
sudo pacman -S archlinux-keyring --needed

## Update the system.
sudo pacman -Syu --overwrite /usr/lib\*/p11-kit-trust.so --noconfirm
yay -Syu --devel --timeupdate --noconfirm

## Install or update standard programs if needed.
sudo pacman -S base-devel --needed --noconfirm
sudo pacman -S iwd --needed --noconfirm
sudo pacman -S ntp --needed --noconfirm
sudo pacman -S pulseaudio --needed --noconfirm
sudo pacman -S pavucontrol --needed --noconfirm
sudo pacman -S python-pip --needed --noconfirm
sudo pacman -S firefox --needed --noconfirm
sudo pacman -S atom --needed --noconfirm
sudo pacman -S gimp --needed --noconfirm
yay -S discord-canary --noconfirm
yay -S polybar --noconfirm
yay -S gitkraken --noconfirm

## Remove unwanted programs which might be present.
sudo pacman -Rns midori
sudo pacman -Rns geany
sudo pacman -Rns networkmanager-dmenu-git
sudo pacman -Rns networkmanager
sudo pacman -Rns nm-connection-editor
sudo pacman -Rns wpa_supplicant
sudo pacman -Rns netctl
sudo pacman -RnS dhcpcd

## Prepare our iwd directory for our Rofi management script to run later.
sudo chmod o=rw /var/lib/iwd
sudo chmod o=rw /var/lib/iwd/*

## Download some nice wallpaper images.
echo "--- Downloading wallpapers. ---"
pip install requests
pip install Pillow
pip install screeninfo
get-wallpapers.sh
echo "--- Downloaded wallpapers. ---"
echo ""

## Download and install the Fira Code fonts on our first execution.
if [ "$first_time" = true ]; then
  echo "--- Downloading and using custom font files. ---"
  fonts_dir="${HOME}/.local/share/fonts"
  if [ ! -d "${fonts_dir}" ]; then
    echo "* making font directory: mkdir -p $fonts_dir"
    mkdir -p "${fonts_dir}"
  else
    echo "* found font directory: $fonts_dir"
  fi

  for type in Bold Light Medium Regular Retina; do
    file_path="${HOME}/.local/share/fonts/FiraCode-${type}.ttf"
    file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
    if [ ! -e "${file_path}" ]; then
      echo "* getting font: wget -O $file_path $file_url"
      wget -O "${file_path}" "${file_url}"
    else
      echo "* found existing font file: $file_path"
    fi;
  done
  echo "* caching font: fc-cache -f"
  fc-cache -f
  fira-code-default.sh
  echo "--- Custom font files set. ---"
  echo ""
fi

## Remove some unneeded content that is included in Archcraft by default.
if [ "$first_time" = true ]; then
  echo "--- Removing unwanted default files. ---"
  sudo rm -rf /usr/share/plymouth/themes/*
  sudo rm -rf /usr/share/backgrounds/
  sudo rm -rf /usr/share/applications/about.desktop
  sudo rm -rf /usr/local/bin/about.sh
  sudo rm -rf /usr/share/adi1090x/
  sudo rm -rf ~/.face
  if [ "$MADE_TIEL_DIR" = true ]; then
    sudo rm -rf ~/Music/*
  fi
  sudo rm -rf /usr/local/bin/apps_as_root.sh
  sudo rm -rf /usr/local/bin/askpass_rofi.sh
  sudo rm -rf /usr/local/bin/askpass_zenity.sh
  sudo rm -rf /usr/local/bin/change_font.sh
  sudo rm -rf /usr/local/bin/set-random-plmouth-theme.sh
  sudo rm -rf /usr/local/bin/ob_powermenu
  sudo rm -rf /usr/local/bin/ob-kb-pipemenu
  echo "--- Unwanted default files removed. ---"
  echo ""
fi

## Update, disable, and reactivate services.
echo "* updating all custom services"
sudo cp -a ./etc/systemd/system/. /etc/systemd/system/
sudo systemctl disable --now random-plymouth-theme.service
sudo systemctl enable --now random-plymouth-theme.service
sudo systemctl enable --now ntpd.service

## Restart Openbox, and we're done!
echo "--- Restarting Openbox to show changes. ---"
openbox --restart
echo "--- All done! Congratulations on the Tiel Standard. ---"
