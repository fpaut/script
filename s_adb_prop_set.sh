#!/bin/bash
if [ "$#" != "2" ]; then
	echo "#1 is property name (like : 'system.at-proxy.mode')"
	echo "#2 is the value"
	exit 1
fi
property=$1
value=$2
cmd="adb shell su -c setprop $property $value"
echo $cmd; $cmd
