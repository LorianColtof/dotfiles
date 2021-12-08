#!/usr/bin/env python3

# This script listens for i3 events and updates workspace names to show icons
# for running programs.  It contains icons for a few programs, but more can
# easily be added by inserting them into WINDOW_ICONS below.
#
# Dependencies
# * xorg-xprop - install through system package manager
# * i3ipc - install with pip
# * fontawesome - install with pip
#
# Installation:
# * Download this script and place it in ~/.config/i3/ (or anywhere you want)
# * Add "exec_always ~/.config/i3/i3-autoname-workspaces.py &" to your i3 config
# * Restart i3: "$ i3-msg restart"
#
# Configuration:
# The default i3 config's keybingings reference workspaces by name, which is an
# issue when using this script because the "names" are constantaly changing to
# show window icons.  Instead, you'll need to change the keybindings to
# reference workspaces by number.  Change lines like:
#   bindsym $mod+1 workspace 1
# To:
#   bindsym $mod+1 workspace number 1


import i3ipc
import subprocess as proc
import re
import signal
import sys
import fontawesome as fa

# Add icons here for common programs you use.  The keys are the X window class
# (WM_CLASS) names (lower-cased) and the icons can be any text you want to
# display.
#
# Most of these are character codes for font awesome:
#   http://fortawesome.github.io/Font-Awesome/icons/
#
# If you're not sure what the WM_CLASS is for your application, you can use
# xprop (https://linux.die.net/man/1/xprop). Run `xprop | grep WM_CLASS`
# then click on the application you want to inspect.
WINDOW_ICONS = {
    'telegram-desktop': fa.icons['telegram'],
    'alacritty': fa.icons['terminal'],
    'termite': fa.icons['terminal'],
    'urxvt': fa.icons['terminal'],
    'chromium': fa.icons['chrome'],
    'google-chrome': fa.icons['chrome'],
    'spotify': fa.icons['spotify'],
    'firefox': fa.icons['firefox'],
    'libreoffice': fa.icons['file-alt'],
    'feh': fa.icons['images'],
    'mupdf': fa.icons['file-pdf'],
    'evince': fa.icons['file-pdf'],
    'zathura': fa.icons['file-pdf'],
    'thunar': fa.icons['file'],
    'nautilus': fa.icons['file'],
    'gpick': fa.icons['eye-dropper'],
    'subl': fa.icons['file-code'],
    'subl3': fa.icons['file-code'],
    'vim': fa.icons['file-code'],
    'atom': fa.icons['file-code'],
    'vscodium': fa.icons['file-code'],
    'code-oss': fa.icons['file-code'],
    'steam': fa.icons['steam'],
    'zenity': fa.icons['window-maximize'],
    'pavucontrol': fa.icons['volume-up'],
    'jetbrains-pycharm': fa.icons['python'],
    'jetbrains-rider': fa.icons['file-code'],
    'jetbrains-phpstorm': fa.icons['php'],
    'vbox-windows-vm': fa.icons['windows']
}

# This icon is used for any application not in the list above
DEFAULT_ICON = fa.icons['window-maximize']


def xprop(win_id, property):
    """
    Returns an array of the values for the given property from xprop.  This
    requires xorg-xprop to be installed.
    """

    try:
        prop = proc.check_output(['xprop', '-id', str(win_id), property],
                                 stderr=proc.DEVNULL)
        prop = prop.decode('utf-8')
        return re.findall('"([^"]+)"', prop)
    except proc.CalledProcessError as e:
        print("Unable to get property for window '%d'" % win_id)
        return None

def icon_for_window(window):
    classes = xprop(window.window, 'WM_CLASS')
    name = xprop(window.window, 'WM_NAME')

    if name is not None and len(name) > 0 and name[0].endswith(' - NVIM'):
        return WINDOW_ICONS['vim']

    if name is not None and len(name) > 0 and classes is not None and \
            "VirtualBox Machine" in classes and \
            'windows' in name[0].lower():
        return WINDOW_ICONS['vbox-windows-vm']

    if classes is not None and len(classes) > 0:
        for cls in classes:
            cls = cls.lower()  # case-insensitive matching
            if cls in WINDOW_ICONS:
                return WINDOW_ICONS[cls]
        print('No icon available for window with classes: %s' % str(classes))
    return DEFAULT_ICON


def rename_workspaces(i3):
    """
    Renames all workspaces based on the windows present
    also renumbers them in ascending order, with one gap left between monitors
    for example: workspace numbering on two monitors: [1, 2, 3], [5, 6]
    """
    for ws_index, workspace in enumerate(i3.get_tree().workspaces()):
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = ' '.join(
            [icon_for_window(w) for w in workspace.leaves()])

        new_name = construct_workspace_name(name_parts)
        i3.command('rename workspace "%s" to "%s"' % (
            workspace.name, new_name))

def undo_window_renaming(i3):
    """
    Rename workspaces to just numbers and shortnames.
    called on exit to indicate that this script is no longer running.
    """

    for workspace in i3.get_tree().workspaces():
        name_parts = parse_workspace_name(workspace.name)
        name_parts['icons'] = None
        new_name = construct_workspace_name(name_parts)
        i3.command('rename workspace "%s" to "%s"' %
                   (workspace.name, new_name))
    i3.main_quit()
    sys.exit(0)


def parse_workspace_name(name):
    """
    Used so that we can keep the workspace's name when we add icons to it.
    Returns a dictionary with the following keys:
    'num', 'shortname', and 'icons'
    Any field that's missing in @name will be None in the returned dict
    """
    return re.match('(?P<num>\d+)(?P<shortname>\w+)? ?(?P<icons>.+)?',
                    name).groupdict()

def construct_workspace_name(parts):
    """
    Given a dictionary with 'num', 'shortname', 'icons',
    return the formatted name by concatenating them together.
    """

    new_name = str(parts['num'])
    if parts['shortname'] or parts['icons']:
        # new_name += ':'

        if parts['shortname']:
            new_name += parts['shortname']

        if parts['icons']:
            new_name += ' ' + parts['icons']

    return new_name


if __name__ == '__main__':
    i3 = i3ipc.Connection()

    # exit gracefully when ctrl+c is pressed
    for sig in [signal.SIGINT, signal.SIGTERM]:
        signal.signal(sig, lambda signal, frame: undo_window_renaming(i3))

    # call rename_workspaces() for relevant window events
    def window_event_handler(i3, e):
        if e.change in ['new', 'close', 'move', 'title']:
            rename_workspaces(i3)
    i3.on('window', window_event_handler)

    rename_workspaces(i3)

    i3.main()
