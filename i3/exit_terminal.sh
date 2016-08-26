#!/bin/bash

_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)
termite -t "Quit i3" --geometry 300x150 -e "zsh -c 'source ~/.zshrc; $_SCRIPTDIR/exit.py'"


