#!/bin/bash
pattern=$1
if [ -z $pattern ]; then
    echo "First parameter could be a pattern"
    locate *.desktop
else
    locate *.desktop | grep "$pattern"
fi
