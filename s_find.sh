#!/bin/bash
PATTERN=$1
FOLDER=$2
echo "Searching file with pattern $PATTERN in folder $FOLDER"
if [[ "$FOLDER" != "" ]]; then
	CMD="for result in \$(find $FOLDER -iname \"*$PATTERN*\" | grep --color=always -i $PATTERN); do  echo \$result; done"
else
	CMD="for result in \$(find . -iname \"*$PATTERN*\" | grep --color=always -i $PATTERN); do echo \$result; done"
fi
echo $CMD
eval $CMD
