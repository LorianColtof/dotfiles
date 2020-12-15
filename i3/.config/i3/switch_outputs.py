#!/usr/bin/env python3
import i3ipc
from ilock import ILock, ILockException
import notify2
from time import sleep

APP_NAME = 'i3-python'


def switch_outputs():
    i3 = i3ipc.Connection()

    active_outputs = sorted((o for o in i3.get_outputs() if o.active),
                            key=lambda o: o.rect.x)
    if len(active_outputs) != 2:
        notify2.init(APP_NAME)
        notify2.Notification(
            f'Cannot switch with {len(active_outputs)} workspace(s).').show()
        return

    ws_left = active_outputs[0].current_workspace

    workspaces = {w.name: w for w in i3.get_workspaces()}

    focused_ws_name = i3.get_tree().find_focused().workspace().name

    if focused_ws_name == ws_left:
        focused_output = active_outputs[0]
        other_output = active_outputs[1]
    else:
        focused_output = active_outputs[1]
        other_output = active_outputs[0]

    focused_ws = workspaces[focused_output.current_workspace]
    other_ws = workspaces[other_output.current_workspace]

    delay = 0.05

    i3.command('move workspace to output ' + other_output.name)
    sleep(delay)

    i3.command('workspace --no-auto-back-and-forth number {}'.format(
        other_ws.num))

    i3.command('move workspace to output ' + focused_output.name)
    sleep(delay)

    i3.command('workspace --no-auto-back-and-forth number {}'.format(
        focused_ws.num))
    sleep(delay)


def main():
    try:
        with ILock(APP_NAME, timeout=0):
            switch_outputs()
    except ILockException:
        print("Lock failed")


if __name__ == "__main__":
    main()
