#!/bin/bash

FILE=/tmp/screenshot.png
PIDFILE=/tmp/i3lock.pid

if [ -e $PIDFILE ]
then
    echo "i3lock is already running with PID $(<$PIDFILE)"
    exit 1
fi

scrot $FILE
mogrify -scale 10% -scale 1000% $FILE
i3lock -i $FILE -n &
PID=$!
echo Running $PID
echo $PID > $PIDFILE

trap "kill $(<$PIDFILE); rm $FILE $PIDFILE" EXIT

wait
