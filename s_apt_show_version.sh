#!/bin/bash
PKG=$1
CMD="dpkg -s $PKG"
echo -e "CMD=$CMD\n\n"
IFS=$'\n'
OUT=($(eval $CMD))
echo -e ${OUT[0]} # Package=
echo -e ${OUT[1]} # Status=
echo -e ${OUT[8]} # Version=
