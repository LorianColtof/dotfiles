#!/bin/bash
_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

if [[ -e ~/.colors_light ]]
then
    NEWMODE='dark'
    rm ~/.colors_light
else
    NEWMODE='light'
    touch ~/.colors_light
fi

i3-style $_SCRIPTDIR/theme-$NEWMODE.yaml -c $_SCRIPTDIR/config-base \
    -o $_SCRIPTDIR/config && i3-msg restart

TERMITE_CONFIG=~/.config/termite/
cat $TERMITE_CONFIG/base.config $TERMITE_CONFIG/colors-$NEWMODE.config \
    > $TERMITE_CONFIG/config

killall -SIGUSR1 termite

for socket in /tmp/nvim*/0
do
    nvr --servername $socket --remote-send "<ESC>:call SetBackgroundColor()<CR>" &
done
