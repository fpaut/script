#!/bin/bash
CMD="adb shell dumpsys meminfo $1"
echo $CMD
$CMD
