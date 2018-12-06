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

$_SCRIPTDIR/reload_config.sh

TERMITE_CONFIG=~/.config/termite/
cat $TERMITE_CONFIG/base.config $TERMITE_CONFIG/colors-$NEWMODE.config \
    > $TERMITE_CONFIG/config

killall -SIGUSR1 termite

if ls /tmp/nvim*/0 &> /dev/null; then
    for socket in /tmp/nvim*/0
    do
        echo $socket
        nvr --nostart --servername $socket --remote-send "<ESC>:call SetBackgroundColor()<CR>" &
    done
fi
