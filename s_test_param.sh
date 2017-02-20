#!/bin/bash
PARAMS=$@
echo "NB PARAM=${#@}"

contains() {
	local search=$1
	local myarray=$2
	echo "contains() $search / $myarray"
	case "${myarray[@]}" in  *$search*) return 0 ;; esac
	return 1
}

for PARAM in $PARAMS
do
	echo "NEXT PARAM=$1"
	shift
done

contains "2" "$PARAMS"
if [ "$?" = "0" ];
then
	echo "PARAMS contains '2'"
fi
