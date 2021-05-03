#!/bin/bash
file=$1
output=$2
if [[ "$output" != "" ]]; then
	option= "-C $output"
fi
CMD="tar -xf $file $option"
echo $CMD
eval $CMD
