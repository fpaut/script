#!/bin/bash
echo $0
FILE_CONDITION=$1
FILEINFO_COND=$2
FILECONTENT_COND=$3
CMD=$4
FOLDER=$5
if [[ "$#" == "0" ]]; then
	echo "#1 : File pattern to find in filename or \"\" for any file"
	echo "#2 : Condition to use in file information (date, attribute and so on) or \"\" for ignore"
	echo "#3 : Condition to use in file content (grep \"toto\" for files containing \"toto\" and so on) or \"\" for ignore"
	echo "#4 : Command to execute on each file found, use :"
	echo "...................................... '&file' in place of the founded filename"
	echo "...................................... '&path' in place of the path of founded file"
	echo "...................................... '&attrib' in place of the attribute of founded file"
	echo ".......... like 'echo PATH=path, FILENAME=file, ATTRIB=attrib'"
	echo "#5 : Base Folder for searching or nothing for local (.)"
	echo
	echo sample "Search in local folder and subfolders, files containing '.LOG' in filename, and for each file, echoing path, filename and attribute"
	echo "$(basename $0) ".LOG" "" "" "echo -e \"PATH=\&path \nFILENAME=\&file \nEXTENSION=\&ext \nATTRIB=\&attrib\"
	echo another sample :
	echo .... Search in folder \"\$HOME\\toto\" files containing \".txt\" in filename, created june 12, and containing string \"toto\" 
	echo .... then copy theirs in \"poubelle\ \"
	echo "$(basename $0) \"txt\" \"june 12\" \"grep \"toto\" \"cp --preserve=all file poubelle\" "\$HOME\\toto""
	exit 1
fi

# Set up some parameters if empty
if [[ "$FOLDER" == "" ]]; then
	FOLDER="."
fi
if [[ "$FILEINFO_COND" == "" ]]; then
	FILEINFO_COND=""
fi



echo "Searching file with pattern $FILE_CONDITION in folder $FOLDER"
echo File pattern=$FILE_CONDITION
echo File information pattern=$FILEINFO_COND
echo Command to execute=$CMD
echo Base folder =$FOLDER

echo "find $FOLDER -iname \"*$FILE_CONDITION*\" -type f -ls | if [[ \"$FILEINFO_COND\" != \"\" ]]; then grep \"$FILEINFO_COND\"; else cat; fi | while read FILE"
find $FOLDER -iname "*$FILE_CONDITION*" -type f -ls | if [[ "$FILEINFO_COND" != "" ]]; then grep "$FILEINFO_COND"; else cat; fi | while read FILE
do 
# Update command line
##DEBUG##	echo FILE=$FILE
	ATTRIB=${FILE% *}
	FILE=${FILE##* }
##DEBUG##	echo ATTRIB extracted=$ATTRIB
##DEBUG##	echo FILE extracted=$FILE
	_PATH=$(dirname $FILE)
	FILE=$(basename $FILE)
	EXT=${FILE##*.}
	BASE=${FILE%.*}
##DEBUG##	echo FILE filtered=$FILE
##DEBUG##	echo PATH filtered=$_PATH
	if [[ "$FILECONTENT_COND" != "" ]]; then
		FILECONTENT_RET=$(cat $FILE | $FILECONTENT_COND)
	else
		FILECONTENT_RET="TRUE"
	fi
##DEBUG##	echo FIND read $FILE
	if [[ "$FILECONTENT_RET" != "" ]]; then
		NEW_CMD="${CMD/&file/$BASE}"
		NEW_CMD="${NEW_CMD/&path/$_PATH}"
		NEW_CMD="${NEW_CMD/&attrib/$ATTRIB}"
		NEW_CMD="${NEW_CMD/&ext/$EXT}"
		
		echo $NEW_CMD
		eval "$NEW_CMD"
	fi
done
