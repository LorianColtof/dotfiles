#!/bin/bash
SCRIPTDIR=$(cd $(dirname $0);echo $PWD)
TMPBG=/tmp/screen.png
LOCK=$SCRIPTDIR/beeldmerk.png
LOCKFILE=/tmp/.i3lock.lock

if [ -a $LOCKFILE ]; then
    echo Already locked
    exit 1
fi

lock() {
    i3lock -i $TMPBG -l $@
}

touch $LOCKFILE
RES=$(xrandr | grep 'current' | sed -E 's/.*current\s([0-9]+)\sx\s([0-9]+).*/\1x\2/')
ffmpeg -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "boxblur=6:1,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG -loglevel quiet

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    kill_i3lock() {
        pkill -xu $EUID "$@" i3lock
    }

    trap kill_i3lock TERM INT

    lock {XSS_SLEEP_LOCK_FD}<&-

    exec {XSS_SLEEP_LOCK_FD}<&-

    while kill_i3lock -0; do
        sleep 0.5
    done
else
    lock -n
fi

rm $TMPBG $LOCKFILE
