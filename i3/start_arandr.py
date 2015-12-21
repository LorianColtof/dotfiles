#!/usr/bin/env python
import i3

if __name__=="__main__":
	workspace = [i for i in range(1,10) if not i in [w['num'] for w in i3.get_workspaces()]][0]
	i3.command('workspace', str(workspace))
	i3.command('exec', 'arandr')
