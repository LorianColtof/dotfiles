#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Topmenu and the submenus are based of the example found at this location http://blog.skeltonnetworks.com/2010/03/python-curses-custom-menu/
# The rest of the work was done by Matthew Bennett and he requests you keep these two mentions when you reuse the code :-)
# Basic code refactoring by Andrew Scheller
import sys
from time import sleep
import curses, os #curses is the interface for capturing key presses on the menu, os launches the files


os.environ.setdefault('ESCDELAY', '25')

screen = curses.initscr() #initializes a new window for capturing key presses
curses.beep()
curses.noecho() # Disables automatic echoing of key presses (prevents program from input each key twice)
curses.cbreak() # Disables line buffering (runs each key as it is pressed rather than waiting for the return key to pressed)
curses.start_color() # Lets you use colors when highlighting selected menu option
screen.keypad(1) # Capture input from keypad



try:
	curses.curs_set(0)
except Exception as e:
#	curses.endwin()
#	raise e
	pass

curses.use_default_colors()
curses.init_pair(1, curses.COLOR_GREEN, -1)

#n = curses.color_pair(1)
n = curses.A_NORMAL 
h = n | curses.A_REVERSE | curses.A_BOLD

#n is the coloring for a non highlighted menu option

MENU = "menu"
COMMAND = "command"
EXITMENU = "exitmenu"

def logout_action():
	if confirmation("Logout"):
		os.system("i3-msg exit")
		return True
	return False


def suspend_action():
	if confirmation("Suspend"):
		os.system("xautolock -locknow")
		sleep(0.8)
		os.system("dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Suspend boolean:true")
		return True
	return False

def reboot_action():
	if confirmation("Reboot"):
		os.system("dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.Reboot boolean:true")
		return True
	return False

def shutdown_action():
	if confirmation("Shutdown"):
		os.system("dbus-send --print-reply --system --dest=org.freedesktop.login1 /org/freedesktop/login1 org.freedesktop.login1.Manager.PowerOff boolean:true")
		return True
	return False

menu_data = {
	'type': MENU, 
	'title': " Please select an option ",
	'options':[
					{'title': "Cancel", 'type': EXITMENU},
					{'title': "Suspend", 'type': COMMAND, 'command': suspend_action},
					{'title': "Log out", 'type': COMMAND, 'command': logout_action},
					{'title': "Reboot", 'type': COMMAND, 'command': reboot_action},
					{'title': "Power off", 'type': COMMAND, 'command': shutdown_action},
		]
	}

# This function displays the appropriate menu and returns the option selected
def runmenu(menu, parent):
	screen.clear()

	optioncount = len(menu['options']) # how many options in this menu

	pos=0 #pos is the zero-based index of the hightlighted menu option. Every time runmenu is called, position returns to 0, when runmenu ends the position is returned and tells the program what opt$
	oldpos=None # used to prevent the screen being redrawn every time
	x = None #control for while loop, let's you scroll through options until return key is pressed then returns pos to program
	
	(max_y, max_x) = screen.getmaxyx()

	# Loop until return key is pressed
	while x != ord('\n'):
		if pos != oldpos:
			oldpos = pos
			screen.border(0)
			screen.addstr(0, (max_x - len(menu['title']))/2, menu['title'], curses.A_BOLD) 

			# Display all the menu items, showing the 'pos' item highlighted
			for index in range(optioncount):
				textstyle = n
				if pos==index:
					textstyle = h
				screen.addstr(2 + index,4, "{0}: {1}".format(index+1, menu['options'][index]['title']), textstyle)
			# Now display Exit/Return at bottom of menu
			textstyle = n
			if pos==optioncount:
				textstyle = h

			screen.refresh()
			# finished updating screen

		x = screen.getch() # Gets user input

		# What is user input?
		if x >= ord('1') and x <= ord(str(optioncount)):
			pos = x - ord('0') - 1 # convert keypress back to a number, then subtract 1 to get index
			if pos > optioncount-1:
				pos = optioncount-1
		elif x == curses.KEY_DOWN: # down arrow
			if pos < optioncount-1:
				pos += 1
			else: pos = 0
		elif x == curses.KEY_UP: # up arrow
			if pos > 0:
				pos += -1
			else: pos = optioncount-1
		elif x == 27:
			return 0

	# return index of the selected item
	return pos

# This function calls showmenu and then acts on the selected item
def processmenu(menu, parent=None):
	optioncount = len(menu['options'])
	exitmenu = False
	while not exitmenu: #Loop until the user exits the menu
		getin = runmenu(menu, parent)
		if menu['options'][getin]['type'] == COMMAND:
			if menu['options'][getin]['command']():
				sys.exit(0)
		elif menu['options'][getin]['type'] == MENU:
			screen.clear() #clears previous screen on key press and updates display based on pos
			processmenu(menu['options'][getin], menu) # display the submenu
			screen.clear() #clears previous screen on key press and updates display based on pos
		elif menu['options'][getin]['type'] == EXITMENU:
			exitmenu = True


def confirmation(action):
	screen.clear()
	title = "{0}: Are you sure?".format(action)


	pos=1 
	oldpos=None # used to prevent the screen being redrawn every time
	x = None #control for while loop, let's you scroll through options until return key is pressed then returns pos to program
	
	(max_y, max_x) = screen.getmaxyx()

	# Loop until return key is pressed
	while x !=ord('\n'):
		if pos != oldpos:
			oldpos = pos
			screen.border(0)
			screen.addstr(0, (max_x - len(title))/2, title, curses.A_BOLD) 

			# Display all the menu items, showing the 'pos' item highlighted
			screen.addstr(max_y/2, 10, "Yes", h if pos == 0 else n)
			screen.addstr(max_y/2, max_x - 10, "No", h if pos == 1 else n)

			screen.refresh()
			# finished updating screen

		x = screen.getch() # Gets user input

		# What is user input?
		
		if x == curses.KEY_LEFT: 
			pos = 0
		elif x == curses.KEY_RIGHT:
			pos = 1
		elif x == 27:
			return 0
		

	# return index of the selected item
	return pos == 0



# Main program
processmenu(menu_data)
curses.endwin() #VITAL! This closes out the menu system and returns you to the bash prompt.
#os.system('clear')
