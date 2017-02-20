#!/bin/bash
PKG=$1

if [ "$PKG" = "" ]; then
	echo "First parameter (package) is empty. Exit..."
	exit 1;
fi

adb backup -f $PKG.ab -apk -obb $PKG
