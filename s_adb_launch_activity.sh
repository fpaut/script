#!/bin/bash
PKG_NAME=$1
ACTIVITY_NAME=$2
PARAMS=$@
if [ "$PARAMS" = "" ]; then
	echo "#1 is package name or 'help'"
	echo "#2 is activity name"
	exit 1
fi
if [ "$2" != "" ]; then
	adb shell am start -n "$PKG_NAME/.$ACTIVITY_NAME"
fi
if [ "$1" = "help" ]; then
	adb shell am start --help
fi
