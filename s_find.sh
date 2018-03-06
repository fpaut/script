#!/bin/sh
PATTERN=$1
CMD="find . -iname \"*$PATTERN*\" | grep --color=always -i $PATTERN"
echo $CMD
eval $CMD