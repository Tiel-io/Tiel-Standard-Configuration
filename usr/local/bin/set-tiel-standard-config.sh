#!/usr/bin/env bash

## Update the value of a particular Tiel Standard configuration variable.
readonly MAIN_CONF="$HOME/.config/tiel-standard/main.conf"
VARIABLE_SWAP=s/$1=.*/$1=${2}/
sed -i "$VARIABLE_SWAP" $MAIN_CONF
