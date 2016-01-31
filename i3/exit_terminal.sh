#!/bin/bash

_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)
urxvt -T "Quit i3" -geometry 40x10 -e $_SCRIPTDIR/exit.py
#termite -t "Quit i3" --geometry 300x150 -e "zsh -c 'source ~/.zshrc; $_SCRIPTDIR/exit.py'"


