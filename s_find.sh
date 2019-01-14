#!/bin/sh
PATTERN=$1
FOLDER=$2
Echo "Searching file with pattern $PATTERN in folder $FOLDER"
if [[ $FOLDER != "" ]]; then
	CMD="for result in \$(find $FOLDER -iname \"*$PATTERN*\" | grep --color=never -i $PATTERN); do cygpath -p \$result; done"
else
	CMD="for result in \$(find . -iname \"*$PATTERN*\" | grep --color=never -i $PATTERN); do cygpath -p \$result; done"
fi
echo $CMD
eval $CMD
