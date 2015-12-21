#!/bin/bash
sleep 1
xrandr --output HDMI1 --auto --left-of VGA1
BACKGROUND=`python -c "from gi.repository import Gio;print Gio.Settings(\"org.cinnamon.desktop.background\").get_string(\"picture-uri\")[7:]"`
feh --bg-fill $BACKGROUND
