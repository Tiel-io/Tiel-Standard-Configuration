#!/bin/bash
scrot 'scrot_%Y-%m-%d-%S_$wx$h.png' -e 'mv $f ~/Pictures ; viewnior ~/Pictures/$f'
