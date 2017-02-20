#!/bin/bash
ADB=$(which adb)
adb kill-server
sudo $ADB start-server
