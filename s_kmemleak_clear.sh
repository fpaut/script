#!/bin/bash
CMD="adb shell su -c echo clear > /sys/kernel/debug/kmemleak"
echo $CMD
eval $CMD
