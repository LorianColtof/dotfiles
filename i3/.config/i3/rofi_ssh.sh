#!/bin/bash
rofi -show ssh -ssh-command "{terminal} -e \"zsh -i -c '{ssh-client} {host}'\""

