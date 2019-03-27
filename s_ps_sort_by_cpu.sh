#!/bin/bash
CMD="ps -e -o pcpu -o pid -o user -o args | sort | grep -v root | grep -v lightdm | grep -v message+ | grep -v colord | grep -v rtkit | grep -v avahi | grep -v syslog"
eval $CMD
echo
echo "-------------------------------------------------------------------------------------------------"
echo "Command is $CMD"
