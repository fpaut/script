#!/bin/bash
CMD="adb shell su -c dmesg -c"
echo "$CMD"
$CMD
CMD="adb logcat -c"
echo "$CMD"
$CMD

