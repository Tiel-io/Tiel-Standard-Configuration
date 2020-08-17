#!/usr/bin/env bash

## This script installs and configures a standard experience over the top of the
## Archcraft OS distributed by Aditya Shakya.
## @author Tim Clancy
## @date 8.17.2020

## Immediately prompt for administrator permissions.
echo "--- Prompting for administrator permission. ---"
sudo ls > /dev/null
echo "--- Permission received. ---"
echo ""

## Create and populate the Tiel standard data folder.
echo "--- Preparing Tiel Standard installation files. ---"
tiel_dir="${HOME}/.tiel-standard"
first_time=false
if [ ! -d "${tiel_dir}" ]; then
  echo "* creating Tiel Standard directory: mkdir -p $tiel_dir"
  mkdir -p "${tiel_dir}"
  first_time=true
else
  echo "* found existing Tiel Standard directory: $tiel_dir"
  first_time=$1
fi

## Pull the most recent standard configuration.
cd "${tiel_dir}"
if [ "$first_time" = true ]; then
  git clone https://github.com/Tiel-io/Tiel-Standard-Configuration.git
fi
cd Tiel-Standard-Configuration
git fetch --all
git reset --hard origin/master
sudo cp -a ./usr/local/bin/. /usr/local/bin/
find /usr/local/bin/ -type f -iname "*.sh" -exec sudo chmod +x {} \;

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
yay --noconfirm

## Install or update standard programs if needed.
sudo pacman -S python-pip --needed
sudo pacman -S firefox --needed
sudo pacman -S atom --needed
sudo pacman -S gimp --needed
yay -S discord-canary --noconfirm
yay -S polybar --noconfirm
yay -S gitkraken --noconfirm

## Remove unwanted programs.
sudo pacman -Rns midori
sudo pacman -Rns geany

## Download some nice wallpaper images.
echo "--- Downloading wallpapers. ---"
cd reddit-wallpaper-downloader
pip install requests
pip install Pillow
pip install screeninfo
python get-walls.py earthporn ~/Pictures/Wallpapers/Reddit/ 10 500 1
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
  sudo rm -rf /usr/share/applications/about.desktop
  sudo rm -rf /usr/local/bin/about.sh
  sudo rm -rf /usr/share/adi1090x/
  sudo rm -rf ~/.face
  sudo rm -rf ~/Music/*
  echo "--- Unwanted default files removed. ---"
  echo ""
fi

## Restart Openbox, and we're done!
echo "--- Restarting Openbox to show changes. ---"
openbox --restart
echo "--- All done! Congratulations on the Tiel Standard. ---"
