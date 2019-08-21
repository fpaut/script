#!/bin/bash
echo $0
FILE_PATTERN=$1
PATTERN=$2
CMD=$3
FOLDER=$4
if [[ "$#" == "0" ]]; then
	echo "#1 : File pattern to find"
	echo "#2 : pattern to use in file information (date, attribute and so on) or \"\" for ignore"
	echo "#3 : Command to execute on each file found (use 'file' for the founded filename and 'path' for the path of founded filename, like 'cp file $HOME'"
	echo "#4 : Base Folder for searching or nothing for local (.)"
	echo
	echo sample "Copy text file found in folder \$HOME\\toto, created the 12 of june in subfolder poubelle (with file informations preserved)"
	echo "$(basename $0) \"txt\" \"\" \"echo File is 'file' && echo Path is 'path'\""
	echo another sample
	echo "$(basename $0) \"txt\" \"june 12\" \"cp --preserve=all file poubelle\" "\$HOME\\toto""
	exit 1
fi

# Set up some parameters if empty
if [[ "$FOLDER" == "" ]]; then
	FOLDER="."
fi
if [[ "$PATTERN" == "" ]]; then
	PATTERN=""
fi



echo "Searching file with pattern $FILE_PATTERN in folder $FOLDER"
echo File pattern=$FILE_PATTERN
echo File information pattern=$PATTERN
echo Command to execute=$CMD
echo Base folder =$FOLDER

echo "find $FOLDER -iname \"*$FILE_PATTERN*\" -type f -ls | if [[ \"$PATTERN\" != \"\" ]]; then grep \"$PATTERN\"; else cat; fi | while read FILE"
find $FOLDER -iname "*$FILE_PATTERN*" -type f -ls | if [[ "$PATTERN" != "" ]]; then grep "$PATTERN"; else cat; fi | while read FILE
do 
# Update command line
##DEBUG##	echo FILE=$FILE
	FILE=${FILE##* }
##DEBUG##	echo FILE extracted=$FILE
	_PATH=$(dirname $FILE)
	FILE=$(basename $FILE)
##DEBUG##	echo FILE filtered=$FILE
##DEBUG##	echo PATH filtered=$_PATH
	NEW_CMD="${CMD/file/$FILE}"
	NEW_CMD="${NEW_CMD/path/$_PATH}"
	
	echo $NEW_CMD
	eval "$NEW_CMD"
done
