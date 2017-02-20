#!/bin/bash
PKG=$1
if [ "$PKG" = "" ]; then
	CMD="adb shell pm list packages -f"
else
	CMD="adb shell pm list packages -f | grep -i $PKG"
fi
echo $CMD
$CMD
echo > /dev/stderr
echo "Command was '$CMD'" > /dev/stderr
