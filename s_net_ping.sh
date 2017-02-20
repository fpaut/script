#!/bin/bash
IP=$1
if [ -z $IP ]; then
	echo "First parameter is IP address, try www.google.fr"
	exit
fi
source $(which s_bash_tools.sh)
while [ true ]
do
	c_exec "ping -c 1 $IP 2>/dev/null 1>&2"
	if [ "$?" = "0" ]; then
		c_exec "notify-send CONNECTED!"
		exit
	else
		sleep 1
	fi
done
