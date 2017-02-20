#! /bin/bash
BUS=$1 # session or system
FILTER=$2 # signal name
CMD="dbus-monitor --$BUS type='method_return,"$FILTER"'"
echo $CMD
$CMD
