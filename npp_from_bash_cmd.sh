#/bin/bash
CMD="$1"
output="$HOME/"$2
if [[ "$2" == "" ]]; then
output="$HOME/npp.txt"
fi

[[ -f "$output" ]] && rm $output
# Replace '|' with '_' in file output
output=$(echo $output | sed 's/|/_/g')
echo File output=$output

# Replace '&&' with consecutive grep (replace '&&' with " | egrep -ni ")
CMD=$(echo $CMD | sed 's/&&/\" | egrep -ni \"/g')             

echo
echo "$CMD"
echo "$CMD > $output"
eval "$CMD > $output"
if [[ "$?" == "0" ]]; then
	CMD="$(which notepadpp) \"$(wslpath -w $output)\""
	echo "$CMD"
	eval "$CMD"
else
	echo -e $RED"Error while execution $CMD"$ATTR_RESET
fi
echo

