#!/bin/bash
if [[ "$#" != "3" ]]; then
	echo "#1 is folder"
	echo "#2 is file extension ('o' for 'file.o', 'bin' for 'file.bin'..."
	echo "#3 is objdump parameters"
	echo "Output will be objdump-#2-\"parameters\""
	echo
	echo "eg.: $0 \"objpmt-hal-f3\" \"o\" \"-tT\""
	echo
	exit 1
fi
echo
folder=$1
ext="$2"
opt=$3
output=objdump-$1$3
echo output="$output"
mkdir -p $output
ls $1/*.$ext | while read file
do
	filename=$(basename $file)
	filename=${filename%$ext*}
	filename+=txt
	CMD="objdump $opt $file > $output/$filename"
	echo "CMD=$CMD"
	eval "$CMD"
done
