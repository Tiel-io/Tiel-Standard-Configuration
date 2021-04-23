#!/usr/bin/env bash

## Use our Rofi password helper to ask for the sudo password.
export SUDO_ASKPASS=/usr/local/bin/rofi-ask-password.sh

# Build Unison from source.
# Remove current references of OCaml.
sudo pacman -Rns opam --noconfirm
sudo pacman -Rns ocaml --noconfirm
sudo rm -r /usr/bin/ocaml*

# Remove current versions of Unison binaries
sudo pacman -Rns unison --noconfirm
sudo rm -r /usr/bin/unison
sudo rm -r /usr/bin/unison-*
sudo rm -r /usr/local/bin/unison
sudo rm -r /usr/local/bin/unison-*

# Install OCaml using the package manager.
opam init
eval $(opam env)
opam switch create 4.05.0
apt-get install ocaml
eval $(opam env)
which ocaml
ocaml -version

# Compile Unison from source.
sudo rm -rf /usr/src/unison/
mkdir -p /usr/src/unison/
cd /usr/src/unison/
wget https://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.51.2/unison-2.51.2.tar.gz -O unison.tar.gz
tar xzvf unison.tar.gz  --strip-components 1
make UISTYLE=text || true

# Make Unison executable.
sudo chmod +x unison unison-*
cp unison /usr/local/bin/unison
find . -name "unison-*" -exec cp '{}' /usr/local/bin/ \;
unison -version
