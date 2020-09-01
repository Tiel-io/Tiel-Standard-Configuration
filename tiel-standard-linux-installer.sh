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
  sudo pacman -Syyu --overwrite /usr/lib\*/p11-kit-trust.so --noconfirm
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
sudo chmod +x ~/.config/polybar/forest/launch.sh
sudo cp -a ./.ncmpcpp/config ~/.ncmpcpp/config

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

## Calculate the user's screen aspect ratio and set up their login screen.
DIMENSIONS=$(xdpyinfo | grep dimensions | sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/')
WIDTH=$(echo $DIMENSIONS | sed -r 's/x.*//')
HEIGHT=$(echo $DIMENSIONS | sed -r 's/.*x//')
ASPECT_RATIO=$(bc -l <<< "$WIDTH/$HEIGHT")
if [ "$ASPECT_RATIO" > 2 ]; then
  sudo cp ./usr/share/lxdm/themes/archcraft/cockatiel-wallpaper-21-9.jpg /usr/share/lxdm/themes/archcraft/bg.png
else
  sudo cp ./usr/share/lxdm/themes/archcraft/cockatiel-wallpaper-16-9.jpg /usr/share/lxdm/themes/archcraft/bg.png
fi
sudo cp ./usr/share/lxdm/themes/archcraft/login.png /usr/share/lxdm/themes/archcraft/login.png
sudo cp ./usr/share/lxdm/themes/archcraft/tiel-white-round-no-edges.png /usr/share/lxdm/themes/archcraft/nobody.png
sudo cp ./usr/share/lxdm/themes/archcraft/greeter-gtk3.ui /usr/share/lxdm/themes/archcraft/greeter-gtk3.ui
sudo cp ./usr/share/lxdm/themes/archcraft/greeter.ui /usr/share/lxdm/themes/archcraft/greeter.ui

## Install the Arch Linux keyring.
sudo pacman -S archlinux-keyring --needed

## Update the system.
sudo pacman -Syu --overwrite /usr/lib\*/p11-kit-trust.so --noconfirm
yay -Syu --devel --timeupdate --noconfirm

## Install or update standard programs if needed.
sudo pacman -S base-devel --needed --noconfirm
sudo pacman -S asar --needed --noconfirm
sudo pacman -S pacman-contrib --needed --noconfirm
sudo pacman -S iwd --needed --noconfirm
sudo pacman -S ntp --needed --noconfirm
sudo pacman -S pulseaudio --needed --noconfirm
sudo pacman -S pavucontrol --needed --noconfirm
sudo pacman -S python-pip --needed --noconfirm
sudo pacman -S firefox --needed --noconfirm
sudo pacman -S atom --needed --noconfirm
sudo pacman -S gimp --needed --noconfirm
sudo pacman -S audacity --needed --noconfirm
sudo pacman -S telegram-desktop --needed --noconfirm
sudo pacman -S signal-desktop --needed --noconfirm
sudo pacman -S hicolor-icon-theme --needed --noconfirm
sudo pacman -S papirus-icon-theme --needed --noconfirm
sudo pacman -S intellij-idea-community-edition --needed --noconfirm
sudo pacman -S calibre --needed --noconfirm
sudo pacman -S geocode-glib --needed --noconfirm
sudo pacman -S graphviz --needed --noconfirm
sudo pacman -S gtkspell3 --needed --noconfirm
sudo pacman -S libgexiv2 --needed --noconfirm
sudo pacman -S osm-gps-map --needed --noconfirm
sudo pacman -S rcs --needed --noconfirm
sudo pacman -S gramps --needed --noconfirm
sudo pacman -S vlc --needed --noconfirm
sudo pacman -S filezilla --needed --noconfirm
sudo pacman -S rust --needed --noconfirm
sudo pacman -S xdotool --needed --noconfirm
sudo pacman -S nvidia --needed --noconfirm
sudo pacman -S nvidia-settings --needed --noconfirm
sudo pacman -S deluge --needed --noconfirm
sudo pacman -S peek --needed --noconfirm
sudo pacman -S obs-studio --needed --noconfirm
sudo pacman -S thunderbird --needed --noconfirm
sudo pacman -S lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader --needed --noconfirm
sudo pacman -S lutris --needed --noconfirm
yay -S bitwarden --noconfirm
yay -S discord-canary --noconfirm
yay -S slack-desktop --noconfirm
yay -S polybar --noconfirm
yay -S gitkraken --noconfirm
yay -S insomnia --noconfirm
yay -S zeal --noconfirm
yay -S angrysearch --noconfirm
yay -S trelby-git --noconfirm
yay -S lib32-nvidia-utils --noconfirm
sudo pacman -S steam --needed --noconfirm

## Blacklist the Nouveau driver and rebuild kernel to activate NVIDIA.
sudo cp ./etc/mkinitcpio.conf /etc/mkinitcpio.conf
sudo cp ./etc/default/grub /etc/default/grub
sudo cp ./etc/modprobe.d/blacklist.conf /etc/modprobe.d/blacklist.conf
sudo cp ./etc/pacman.d/hooks/nvidia.hook /etc/pacman.d/hooks/nvidia.hook
set-tiel-standard-config.sh RANDOMIZE_BOOT true
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo set-random-plymouth-theme.sh

## Remove potentially-stale Python dependencies.
sudo pip uninstall -y wheel
sudo pip uninstall -y Pillow
sudo pip uninstall -y screeninfo
sudo pip uninstall -y pycountry
sudo pip uninstall -y requests
pip uninstall wheel
pip uninstall requests
pip uninstall Pillow
pip uninstall screeninfo
pip uninstall pycountry

## Remove unwanted programs which might be present.
sudo pacman -Rns midori --noconfirm
sudo pacman -Rns geany --noconfirm
sudo pacman -Rns networkmanager-dmenu-git --noconfirm
sudo pacman -Rns networkmanager --noconfirm
sudo pacman -Rns nm-connection-editor --noconfirm
sudo pacman -Rns wpa_supplicant --noconfirm
sudo pacman -Rns netctl --noconfirm
sudo pacman -RnS dhcpcd --noconfirm

## Prepare our iwd directory for our Rofi management script to run later.
sudo chmod o=rw /var/lib/iwd
sudo chmod o=rw /var/lib/iwd/*

## Install ytmdl.
sudo pacman -S python-requests --needed --noconfirm
sudo pacman -S python-wheel --needed --noconfirm
if [ "$first_time" = true ]; then
  git clone https://github.com/deepjyoti30/ytmdl
fi
cd ytmdl
git fetch --all
git reset --hard origin/master
sudo python setup.py install
cd ../

## Install howdoi.
if [ "$first_time" = true ]; then
  git clone https://github.com/gleitz/howdoi.git
fi
cd howdoi
git fetch --all
git reset --hard origin/master
sudo python setup.py install
cd ../

## Install autoplank.
if [ "$first_time" = true ]; then
  git clone https://github.com/olback/autoplank.git
fi
cd autoplank
git fetch --all
git reset --hard origin/master
cargo build --release
cp ./target/release/autoplank /usr/local/bin/autoplank
sudo chmod +x /usr/local/bin/autoplank
cd ../

## Copy Atom's configuration settings.
sudo cp -a ./.atom/config.cson ~/.atom/config.cson

## Download some nice wallpaper images.
echo "--- Downloading wallpapers. ---"
sudo pacman -S python-pillow --needed --noconfirm
yay -S python-screeninfo --noconfirm
sudo pacman -S python-pycountry --needed --noconfirm
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
  sudo rm -rf /usr/local/bin/ob-places-pipemenu
  sudo rm -rf /usr/local/bin/ob-recent-files-pipemenu
  sudo rm -rf /usr/local/bin/shotArea
  sudo rm -rf /usr/local/bin/shotin5
  sudo rm -rf /usr/local/bin/shotin10
  sudo rm -rf /usr/local/bin/shotnow
  sudo rm -rf /usr/local/bin/shotWindow
  sudo rm -rf ~/.config/plank/dock1/launchers/applications.dockitem
  sudo rm -rf ~/.config/plank/dock1/launchers/xfce-settings-manager.dockitem
  sudo rm -rf /etc/mpd.conf
  sudo rm -rf ~/.config/polybar/beach
  sudo rm -rf ~/.config/polybar/grid
  sudo rm -rf ~/.config/polybar/manhattan
  sudo rm -rf ~/.config/polybar/spark
  sudo rm -rf ~/.config/polybar/wave
  sudo rm -rf /usr/local/bin/autoplank.sh
  sudo rm -rf /etc/systemd/system/start-autoplank.service
  echo "--- Unwanted default files removed. ---"
  echo ""
fi

## Start/restart autoplank.
/usr/local/bin/autoplank &

## Update, disable, and reactivate services.
echo "* updating all custom services"
sudo cp -a ./etc/systemd/system/. /etc/systemd/system/
sudo systemctl disable --now random-plymouth-theme.service
sudo systemctl enable --now random-plymouth-theme.service
sudo systemctl disable --now search-indexer.timer
sudo systemctl enable --now search-indexer.timer
sudo systemctl enable --now ntpd.service
sudo systemctl enable --now deluged.service
sudo systemctl enable --now deluge-web.service

## Restart Openbox, and we're done!
echo "--- Restarting Openbox to show changes. ---"
openbox --restart
echo "--- All done! Congratulations on the Tiel Standard. ---"
