#! /bin/bash
BUS=$1 # session or system
FILTER=$2 # signal name
CMD="dbus-monitor --$BUS type='signal,"$FILTER"'"
echo $CMD
$CMD
