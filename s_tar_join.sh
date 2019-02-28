#!/bin/bash
file=$1
output=$2
option=$file
if [[ "$output" != "" ]]; then
	option="$output/$file"
fi
option=$option
CMD="cat $file* > $option.tar.bz2"
echo $CMD
eval $CMD
