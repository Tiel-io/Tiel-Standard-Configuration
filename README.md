# Tiel Standard Configuration
This repository contains configuration scripts for applying a custom, consistent, and opinionated base Arch Linux installation on top of a pre-installed [Archcraft OS](https://github.com/archcraft-os/archcraft/) experience. The idea is that the systems used by [Tiel](https://www.tiel.io/) should be simple and easy for everyone involved to setup and configure.

## Usage
Download and run the `tiel-standard-linux-installer.sh` script. This script itself can be downloaded and executed using the contents of the `tiel-standard-bootstrapper.sh` script or by entering the following sequence of commands into your terminal:
```
mkdir ~/.tiel-standard
cd ~/.tiel-standard
wget -O tiel-standard-linux-installer.sh https://raw.githubusercontent.com/Tiel-io/Tiel-Standard-Configuration/master/tiel-standard-linux-installer.sh
sudo chmod +x tiel-standard-linux-installer.sh
./tiel-standard-linux-installer.sh true
sudo rm ~/.tiel-standard/tiel-standard-linux-installer.sh
```
The script downloads the files it needs to perform its job to the `~/.tiel-standard/` directory. If this directory does not exist, the script assumes that it is performing a full first-time setup. If the directory _does_ exist, you can still force the application to act as if it were performing its first-time setup by passing a `true` parameter, `./tiel-standard-linux-installer.sh true`.

## Special Thanks
Special thanks is owed to the following organizations and people, without whose work this standard configuration would not be possible.
- [Arch Linux](https://www.archlinux.org/), a lightweight and flexible Linux distribution with an active and supportive community.
- [Aditya Shakya](https://github.com/adi1090x) for creating [Archcraft OS](https://archcraft-os.github.io/), a custom Linux distribution completely dependent on Arch Linux.
- [Zach Baylin](https://github.com/zbaylin) whose [rofi-wifi-menu](https://github.com/zbaylin/rofi-wifi-menu) served as the inspiration and base for [Tim Clancy](https://github.com/TimTinkers)'s crudely-modified [rofi-iwd-menu](https://github.com/TimTinkers/rofi-iwd-menu) project used here.
- [MrSorensen](https://github.com/mrsorensen) whose [reddit-wallpaper-downloader](https://github.com/mrsorensen/reddit-wallpaper-downloader) served as the base for the wallpaper downloader included in this configuration.
- all of the diligent maintainers of the [Arch Linux Wiki](https://wiki.archlinux.org/), the greatest learning resource in creating this work.
