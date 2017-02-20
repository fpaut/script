#!/bin/bash
PARAM=$@
if [ -z "$PARAM" ]; then
	CMD="update-java-alternatives -l"
	echo "$CMD"
	eval $CMD
	echo "Relaunching and give the java name as first parameter"
else
	CMD="sudo update-java-alternatives $PARAM"
	echo $CMD
	eval $CMD
fi

