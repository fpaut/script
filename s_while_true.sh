#! /bin/bash
CMD=$1
DELAY=$2
echo 'execute: '$CMD' every '$DELAY' seconds'
while true; do
	$CMD
	sleep $DELAY
done
