#!/bin/bash
PKG_NAME=$1
PARAMS=$@
if [ "$PARAMS" = "" ]; then
	echo "#1 is package name or 'help'"
	exit 1
fi
if [ "$1" != "help" ]; then
	CMD="adb shell dumpsys package $PKG_NAME"
	$CMD
fi
if [ "$1" = "help" ]; then
	CMD="adb shell dumpsys --help"
	$CMD
fi
echo > /dev/stderr
echo "Command was '$CMD'" > /dev/stderr
