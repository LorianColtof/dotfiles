#!/bin/bash
SCRIPTDIR=$(cd $(dirname $0);echo $PWD)
TMPBG=/tmp/screen.png
LOCK=$SCRIPTDIR/beeldmerk.png
LOCKFILE=/tmp/.i3lock.lock

if [ -a $LOCKFILE ]; then
    echo Already locked
    exit 1
fi

touch $LOCKFILE
RES=$(xrandr | grep 'current' | sed -E 's/.*current\s([0-9]+)\sx\s([0-9]+).*/\1x\2/')
ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "boxblur=6:1,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG -loglevel quiet

i3lock -i $TMPBG -l -n
rm $TMPBG $LOCKFILE
