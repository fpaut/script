#!/bin/bash
PKG_NAME=$1
PARAMS=$@
if [ "$PARAMS" = "" ]; then
	echo "#1 is package name or 'help'"
	exit 1
fi
if [ "$1" != "help
" ]; then
	adb shell aapt dump badging $PKG_NAME
fi
if [ "$1" = "help" ]; then
	adb shell aapt --help
fi
