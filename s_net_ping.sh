#!/bin/bash
# To work with "indicator-sysmonitor"
TIMEOUT=10

HOST=$1
FILE="dummy.txt"
if [ -z $HOST ]; then
	HOST="http://fpaut.free.fr/$FILE"
fi

#Timeout de 5s
wget -T $TIMEOUT $HOST 2>/dev/null 1>&2
if [ "$?" = "0" ]; then
    echo "Ok" 
else
    # Waiting 3 disconnect before declaring Disconnected
        echo "!!! DOWN !!!"; notify-send -t 200 DISCONNECTED!
fi
eval rm "$FILE*" 2>/dev/null 1>&2
