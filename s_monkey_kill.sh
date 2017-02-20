#!/bin/bash
# Seed value for pseudo-random number generator. If you re-run the Monkey with the same seed value, it will generate the same sequence of events
psm=$(adb shell ps | grep monkey)
set -- $psm
pid=$2
CMD="adb shell kill $pid"
echo $CMD
eval $CMD
