#!/bin/bash

setxkbmap -option caps:ctrl_modifier -option grp:shifts_toggle

killall xcape
xcape  -e 'Caps_Lock=Escape'
