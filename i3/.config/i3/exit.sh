#!/bin/bash

function confirm {
    answer=$(echo -ne "Yes|No" | rofi -dmenu -lines 2 -theme-str 'window {width: 20%; height: 10%;}' -i -p "Are you sure you want to $1? " \
        -sep '|' -hide-scrollbar -select 'No')
    if [[ $? -eq 0 ]] && [ $answer == "Yes" ]
    then
        return 0
    else
        return 1
    fi
}

function action_suspend {
    if ! confirm "suspend"
    then
        return 1
    fi

    systemctl suspend
}

function action_hibernate {
    if ! confirm "hibernate"
    then
        return 1
    fi

    systemctl hibernate
}

function action_log_out {
    if ! confirm "log out"
    then
        return 1
    fi

    i3-msg exit
}

function action_reboot {
    if ! confirm "reboot"
    then
        return 1
    fi

    systemctl reboot
}

function action_poweroff {
    if ! confirm "poweroff"
    then
        return 1
    fi

    systemctl poweroff
}


c=1

while ! [[ $c -eq 0 ]]
do
    action=$(echo -ne "Suspend|Hibernate|Log out|Reboot|Poweroff" | rofi -sep "|" -dmenu -lines 5 -theme-str 'window {width: 20%; height: 15%;}' \
        -i -hide-scrollbar -no-custom -p "Action")

    case $action in
        "Suspend")
            action_suspend
            ;;
        "Hibernate")
            action_hibernate
            ;;
        "Log out")
            action_log_out
            ;;
        "Reboot")
            action_reboot
            ;;
        "Poweroff")
            action_poweroff
            ;;
        *)
            exit 0
            ;;
    esac
    c=$?
done
