#!/bin/bash
scrot -d $1 'scrot_%Y-%m-%d-%S_$wx$h.png' -e 'mv $f ~/Pictures ; viewnior ~/Pictures/$f'
