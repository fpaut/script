#!/bin/bash
# To work with "indicator-sysmonitor"
TIMEOUT=10

HOST=$1
OUTPUT="/tmp/NET_TEST"
FILE=""
if [ -z $HOST ]; then
	HOST="www.cdiscount.com/$FILE"
fi

# Timeout
OPTIONS="-T $TIMEOUT "
# Ne rien télécharger
OPTIONS+="--spider "

#is it connected through a VPN?
VPN=$(ifconfig | grep "tun")
[[ "$VPN" != "" ]] && RESULT="VPN-"

#Timeout de 5s
wget $OPTIONS $HOST --output-document=$OUTPUT 2>/dev/null 1>&2
if [ "$?" = "0" ]; then
    RESULT+="Ok" 
else
    # Waiting 3 disconnect before declaring Disconnected
        RESULT+="!!! DOWN !!!"; notify-send -t 200 DISCONNECTED!
fi

#is WIFI connected as a HOTSPOT?
HOTSPOT=$(iw dev | grep "type AP")
[[ "$HOTSPOT" != "" ]] && RESULT+="-HOTSPOT"


echo "$RESULT"
eval rm "$OUTPUT*" 2>/dev/null 1>&2
