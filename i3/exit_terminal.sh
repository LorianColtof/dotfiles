#!/bin/bash

_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)
gnome-terminal -t "Quit i3" --geometry=40x10 --hide-menubar --window-with-profile=NoScrollbar -e \
	"bash -c \"$_SCRIPTDIR/exit.py\"" 
