#!/bin/bash

#alias declaratiessl="xdg-open ~/Dropbox/SSL-Leiden/Declaraties/current/Declaratie_SSL_Lorian_Coltof_ExtraWerkzaamheden.xls"

#source $(dirname "$0")/aliases

export WINEDEBUG=-all
export WINEPREFIX=~/.wine32
export MONO_MWF_SCALING=disable

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: $(~/Dropbox/pwd_tilde.py)\007"'

export PYTHONPATH=/home/lorian/Dropbox/UvA/ICS/

#export PATH=$PATH:/home/lorian/.cabal/bin:/opt/ghc/7.8.4/bin
export PATH=$PATH:/opt/cabal/head/bin:/opt/ghc/7.8.4/bin
export EDITOR=vim
