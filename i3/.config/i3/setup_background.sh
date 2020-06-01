#!/bin/bash

BACKGROUNDS=(~/wallpapers/*)

index=$(($RANDOM % ${#BACKGROUNDS[@]}))
BACKGROUND=${BACKGROUNDS[$index]}
feh --bg-fill $BACKGROUND
