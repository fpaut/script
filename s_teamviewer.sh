#!/bin/bash
VERSION=$1
if [[ "$VERSION" == "" ]]; then
	echo "First parameter must be the teamviewer version (10, 11, 12, 14...)"
	exit 1
fi
exe()
{
	CMD="$1"
	echo $CMD
	eval "$CMD"
}
exe "sudo killall teamviewerd"
exe "sudo killall TeamViewer.exe"
exe "sudo killall TVGuiSlave.64"
exe "sudo killall TeamViewer"
teamviewer_path=teamviewer_$VERSION
exe "rm ~/.config/teamviewer"
exe "ln -s ~/.config/$teamviewer_path ~/.config/teamviewer"
exe "sudo rm /opt/teamviewer"
exe "sudo ln -s /opt/$teamviewer_path /opt/teamviewer"
exe "sudo teamviewer --daemon enable"
exe "sleep 2"
exe "teamviewer&"

