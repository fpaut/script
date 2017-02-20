#!/bin/bash
STATE=$1
if [ "$STATE" = "" ]; then
	echo "One parameter required 'on'/'off'"
	exit 1
fi
CMD="adb shell su -c echo stack=$STATE > /sys/kernel/debug/kmemleak"
echo $CMD
eval $CMD
