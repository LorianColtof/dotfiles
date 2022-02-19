#!/bin/bash

BACKGROUNDS=(~/wallpapers/*)
CURRENT_BG_PATH=~/.current_background

case $1 in
    --random)
        index=$(($RANDOM % ${#BACKGROUNDS[@]}))
        ;;
    --current)
        if [[ ! -e $CURRENT_BG_PATH ]]; then
            echo "Missing $CURRENT_BG_PATH"
            exit 1
        fi

        index=$(cat $CURRENT_BG_PATH)
        ;;
    *)
        echo "Usage: $0 [--random|--current]"
        exit 1
        ;;
esac

BACKGROUND=${BACKGROUNDS[$index]}
feh --bg-fill $BACKGROUND
echo $index > $CURRENT_BG_PATH
