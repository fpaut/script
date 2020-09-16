#!/bin/bash
delay=$1
if [[ "$delay" == "" ]]; then
    echo "#1 is the delay before screensaver activation (in 's')"
    exit 1
fi

PID=$$
echo PID=$PID
while true
do
sleep $delay
xscreensaver-command -activate
done