#!/bin/bash
CMD="adb shell su -c dmesg"
echo "$CMD"
$CMD > ./dut_log_dmesg.txt
CMD="adb logcat -d"
echo "$CMD"
$CMD > ./dut_logcat.txt

echo "********** DMESG **********"
cat ./dut_log_dmesg.txt

echo "********** LOGCAT **********"
cat ./dut_logcat.txt
