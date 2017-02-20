#!/bin/bash
CMD="adb root"
echo $CMD && $CMD
CMD="adb remount"
echo $CMD && $CMD
CMD="adb push Inst/ /"
echo $CMD && $CMD
