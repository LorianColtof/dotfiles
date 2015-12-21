#!/bin/bash
# Sets the background image with feh from the settings of Cinnamon

BACKGROUND=$(gsettings get org.cinnamon.desktop.background picture-uri)
BACKGROUND=${BACKGROUND#\'file://}
BACKGROUND=${BACKGROUND%\'}
feh --bg-fill $BACKGROUND
