#!/bin/bash

delay=$1

if [[ "$delay" == "" ]]; then
    echo "First parameter is delay (in min) before shutdown"
    echo
    echo "Launch with 'sudo'"
    echo
    exit 1
fi

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

loop=$(($delay * 60))
while [[ "$loop" != "0" ]]
do
    echo $loop
    sleep 1s
    loop=$(($loop - 1))
done
shutdown --poweroff 