#!/bin/bash
hour=$1
fchar=${hour:0:1}
if [[ "$fchar" == "0" ]]; then
	fchar=${hour:1}
else
	fchar=$hour
fi
asciiHour=$(( 65 + $hour ))

printf "hour $hour -> \x$(printf %x $asciiHour)"
echo

