#!/bin/bash

if [[ -z "$1" ]];
then
	Filename=""
elif [[ "$1" =~ ^\/.+$ ]]; 
then
	Filename="z:${1//\//\\}"
else
	Pwd=$(pwd)
	Filename="z:${Pwd//\//\\}\\${1//\//\\}"
fi

#notify-send $WINEPREFIX
wine "$WINEPREFIX/dosdevices/c:/Program Files/Adobe/Adobe Photoshop CS6/Adobe Photoshop CS6/PhotoshopCS6.exe" $Filename &

