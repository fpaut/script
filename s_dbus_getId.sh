#! /bin/bash
BUS=$1
SERVICE=$2
dbus-send --print-reply --$BUS --dest="org.freedesktop.DBus" /org/freedesktop/DBus org.freedesktop.DBus.GetNameOwner string:$SERVICE