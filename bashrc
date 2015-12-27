#!/bin/bash

_SCRIPTDIR=/home/lorian/Dropbox/dotfiles
#alias declaratiessl="xdg-open ~/Dropbox/SSL-Leiden/Declaraties/current/Declaratie_SSL_Lorian_Coltof_ExtraWerkzaamheden.xls"

source $_SCRIPTDIR/aliases
source $_SCRIPTDIR/env

export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: $(~/Dropbox/pwd_tilde.py)\007"'

export PYTHONPATH=/home/lorian/Dropbox/UvA/ICS/

export EDITOR=vim
