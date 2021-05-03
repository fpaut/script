#!/bin/bash
min=$1
min1=$min
fchar=${min:0:1}
if [[ "$fchar" == "0" ]]; then
	fchar=${min1:1}
else
	fchar=$min1
fi

asciiMin=$(($min1 / 3))
asciiMin=$(( 97 + $asciiMin ))

printf "min $min -> \x$(printf %x $asciiMin)"
echo

