#!/bin/bash
folder=$1
output=$2
echo "folder=$folder"
echo "output=$output"
if [[ "$output" != "" ]]; then
	option="$output/$(basename $folder)"
fi
option=$option
echo "option=$option"

CMD="tar -czf - $folder/* | split -b 4M - \"$option-part\""
echo $CMD
eval $CMD

