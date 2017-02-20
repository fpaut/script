#!/bin/bash
STRING=$@
set -- $STRING
while [ "$#" -gt 0 ];
do
	SUB_STR=$1
	CMD="adb shell input text $SUB_STR"
	echo $CMD
	$CMD
	if [ "$?" != "0" ]; then
		exit $?
	fi
	if [ "$#" -gt 0 ]; then
		adb shell input keyevent 62
	fi
	shift
done
