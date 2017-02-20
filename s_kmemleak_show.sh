#!/bin/bash
CMD="adb shell su -c cat /sys/kernel/debug/kmemleak"
echo $CMD
eval $CMD
