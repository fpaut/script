#!/bin/bash
exe ()
{	local cmd
	cmd=$1
	echo $cmd; eval $cmd
	echo
	if [[ "$?" != "0" ]]; then
                echo $CMD" FAILED!"
		exit
	fi
}

FILE_IN=$1

filename="$1"
## FILE_WITHOUT_EXT="${filename%.*}"
## EXT=${filename#*.}
## ORIG_FILE=$FILE_WITHOUT_EXT"_ORIG".$EXT

exe "mkdir rotated"
exe "mencoder $filename -o rotated/$filename -oac pcm -ovc lavc -vf rotate=1"
