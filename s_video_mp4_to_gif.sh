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
filename="$(basename $1)"
FILE_OUT="${filename%.*}.gif"

exe "mkdir -p frames"
exe "avconv -i $FILE_IN  -r 5 'frames/frame-%03d.jpg'"
exe "cd frames"
exe "convert -delay 20 -loop 0 *.jpg $FILE_OUT"
exe "cd .."
exe "mv frames/$FILE_OUT ."
## exe "rm -rf frames"

