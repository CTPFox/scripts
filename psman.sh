#!/bin/bash
#creates a searchable menu for man
#which will render your selection in postscript
#and display it in zathura
#Prerequisites: dmenu, zathura
man -k . | dmenu -l 30 | xargs -r man -Tps | zathura -
