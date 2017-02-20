#!/bin/bash
FONT_RED="\e[91m"
FONT_GREEN="\e[92m"
FONT_YELLOW="\e[93m"
FONT_BLUE="\e[34m"
FONT_CYAN="\e[96m"
ATTR_RESET="\e[0m"
exec 5>&1

run() {
	CMD=$@
	echo -e $FONT_GREEN"Running '$CMD'" > /dev/stderr
	exec $CMD
	ERR=$?
	if [ "$ERR" != "0" ]; then
		echo -e $FONT_RED"Command '$CMD' failed ($ERR)"
	fi
	echo -en $ATTR_RESET
	return $ERR
}

run '# define an array ("export" if for sample script)'
run 'declare -a array=("a" "b" "c" "d"); export array'
run 'echo ${array[@]}'

run '# Length of the Array'
run 'echo ${#array[@]}'

