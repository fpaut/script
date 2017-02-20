#!/bin/bash
SCRIPT=$0
PID=$$
FONT_RED="\e[91m"
FONT_GREEN="\e[92m"
FONT_YELLOW="\e[93m"
FONT_BLUE="\e[34m"
FONT_CYAN="\e[96m"
ATTR_RESET="\e[0m"

exec 5>&1

IP=$(ifconfig | grep vpn0)
echo -en $FONT_BLUE
if [ "$IP" = "" ]; then
	IP=$(ifconfig | grep Bcast)
	IP=${IP##*inet addr:}
	IP=${IP%% Bcast:*}
	echo -e "IP address (ethx) = $IP"
else
	IP=$(ifconfig | grep 'P-t-P')
	IP=${IP##* P-t-P:}
	IP=${IP%% Mask*}
	echo -e "IP address (VPN) = $IP"
fi

process_msg() {
	notify-send "Received from Tequila : eval '$@'"
	SVG_IFS=$IFS
	IFS=$';'
	set -- $@
	while [ $# -gt 0 ];
	do
		if [ ${#1} -gt 0 ]; then
			CMD="$1"
			echo -e "***$FONT_GREEN Execute $CMD$ATTR_RESET ***"
			OUT=$(eval $CMD | tee /dev/fd/5)
			if [ "$OUT" != "" ]; then
				echo -e "$FONT_RED Result:$ATTR_RESET $OUT"
			fi
			echo -e "***$FONT_CYAN Waiting next command...$ATTR_RESET ***"
		else
			echo -e "***$FONT_CYAN Empty command...$ATTR_RESET ***"
		fi
		shift
	done
}


echo -e "new PID=$PID"$ATTR_RESET
port=3333
nc -k -l $port | while read msg; do process_msg "$msg"; done
