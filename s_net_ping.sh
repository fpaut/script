#!/bin/bash
# To work with "indicator-sysmonitor"
TIMEOUT=10

HOST=$1
OUTPUT="./NET_TEST"
FILE=""
if [ -z $HOST ]; then
	HOST="www.cdiscount.com/$FILE"
fi

#Timeout de 5s
wget -T $TIMEOUT $HOST --output-document=$OUTPUT 2>/dev/null 1>&2
if [ "$?" = "0" ]; then
    echo "Ok" 
else
    # Waiting 3 disconnect before declaring Disconnected
        echo "!!! DOWN !!!"; notify-send -t 200 DISCONNECTED!
fi
eval rm "$OUTPUT*" 2>/dev/null 1>&2
