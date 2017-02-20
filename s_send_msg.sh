#!/bin/bash
IP=$1
shift
MSG="$@"
if [ "$IP" = "" ]; then
	echo "Missing first parameter (IP address)"
	exit 1
fi

CMD="nc $IP 3333 <<< \"$MSG\""
echo $CMD
eval $CMD
