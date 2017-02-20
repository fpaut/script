#!/bin/bash
CTS_CMD=$1
LOG_SUFFIX=$2
echo "Running one time $CTS_CMD"
adb logcat -c
adb shell su -c dmesg -C > /dev/null
./cts-tradefed $CTS_CMD <<< exit
adb logcat -d > ./logcat_$LOG_SUFFIX.txt
adb shell su -c dmesg > ./dmesg_$LOG_SUFFIX.txt
exit






COUNT=0
while true;
do
	COUNT=$(($COUNT + 1))
	echo -n "$COUNT:"
	adb logcat -c
	adb shell su -c dmesg -C > /dev/null
	FAIL=$(echo | ./cts-tradefed $CTS_CMD | grep FAIL)
	if [ "$FAIL" != "" ]; then
		echo -n "NOK-"
		adb logcat -d > ./logcat_$LOG_SUFFIX.txt
		echo "Logcat dumped!"
		adb shell su -c dmesg > ./dmesg_$LOG_SUFFIX.txt
		echo "Dmesg dumped!"
		exit
	else
		echo -n "OK-"
	fi
done
