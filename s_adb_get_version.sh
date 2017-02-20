#!/bin/bash
##
CMD="adb wait-for-device"; echo $CMD; $CMD
##
CMD="adb shell getprop ro.product.device"
echo "DEVICE ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.id"
echo "BUILD ID ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.user"
echo "BUILD USER ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.version.release"
echo "BUILD RELEASE ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.version.sdk"
echo "BUILD SDK ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.version.incremental"
echo "BUILD TIMESTAMP ($CMD)"
$CMD
##
CMD="adb shell getprop ro.build.description"
echo "BUILD DESCRIPTION ($CMD)"
$CMD
