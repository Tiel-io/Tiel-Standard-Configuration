#!/bin/bash
scrot -s 'scrot_%Y-%m-%d-%S_$wx$h.png' -e 'mv $f ~/Pictures ; viewnior ~/Pictures/$f'
