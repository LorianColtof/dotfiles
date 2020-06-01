#!/bin/bash

_ZSH_CONFIGDIR=~/.config/zsh-dotfiles

export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "

source $_ZSH_CONFIGDIR/aliases
source $_ZSH_CONFIGDIR/env
