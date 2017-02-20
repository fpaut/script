#!/bin/bash

adb_shell() {
  local cmd=$@
  out=$(adb shell $cmd)
  if [ "$out" != "" ]; then
	out=$(echo $out | tr -d '\r' | tr -d '\n')
	echo $out
  fi
}


airplane_on() {
	local cmd
	cmd="adb shell settings put global operator_name_mode_on 1"; echo $cmd; eval $cmd
	cmd="adb shell am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true"; echo $cmd; eval $cmd
	operator_name="dummy value"
	echo "Check if device in operator_name mode... operator_name=$operator_name"
	while [ "$operator_name" != "" ];
	do
		echo -n "."
		operator_name=$(adb_shell getprop gsm.operator.alpha)
	done
	echo "Device in airplane mode!"
	adb logcat -c
}

airplane_off() {
	local cmd
	cmd="adb shell settings put global operator_name_mode_on 0"; echo $cmd; eval $cmd
	cmd="adb shell am broadcast -a android.intent.action.AIRPLANE_MODE --ez state false"; echo $cmd; eval $cmd
	echo "Check if device exited from operator_name mode...operator_name=$operator_name"
	while [ "$operator_name" = "" ];
	do
		echo -n "."
		operator_name=$(adb_shell getprop gsm.operator.alpha)
	done
	echo "Device connected!"
	adb logcat -c
}

count=0
while [ $count -lt 10 ];
do
	airplane_on
	airplane_off
	count=$(($count + 1))
	echo "count=$count"
done
