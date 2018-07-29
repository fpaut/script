#!/bin/bash
# To work with "indicator-sysmonitor"
SERVICE_NAME=$1
if [ -z $SERVICE_NAME ]; then
	echo You must provide a service name as first parameter
	echo or "list-running-service" "list-stopped-service" "list-all-service"
	exit
fi

case $SERVICE_NAME in
	list-running-service)
		CMD="service --status-all | grep --color=auto  '\[ + \]'"
	;;
	list-stopped-service)
		CMD="service --status-all | grep --color=auto  '\[ - \]'"
	;;
	list-all-service)
		CMD="service --status-all"
	;;
	*)
  		CMD="journalctl -f -u $SERVICE_NAME -b"
  	;;
esac
echo $CMD && eval "$CMD"

