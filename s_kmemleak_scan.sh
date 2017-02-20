#!/bin/bash
STATE=$1
if [ "$STATE" = "" ]; then
	echo "One parameter required 'on'/'off'/second"
	exit 1
fi
CMD="adb shell su -c echo scan=$STATE > /sys/kernel/debug/kmemleak"
echo $CMD
eval $CMD
