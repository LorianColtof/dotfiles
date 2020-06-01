#!/bin/bash
_SCRIPTDIR=$(cd $(dirname $0);echo $PWD)

set -e

if [[ -e ~/.colors_light ]]
then
    MODE='light'
else
    MODE='dark'
fi

i3-style $_SCRIPTDIR/theme-$MODE.yaml -c $_SCRIPTDIR/config-base \
    -o $_SCRIPTDIR/config

if [[ $1 == '--restart' ]]; then
    i3-msg restart
else
    i3-msg reload
fi

