#/bin/bash
CMD="$1"
if [[ "$2" == "" ]]; then
	output="./npp.txt"
else
	output="$2"
	# Be sure output filename doesn't contains pipe '|' or '&&' (replace it with '_' if any)
	output=$(echo "$output " | sed 's/|/_/g')
	output=$(echo "$output " | sed 's/&&/_/g')
fi

[[ -f "$output" ]] && rm $output

# Replace '&&' with consecutive grep (replace '&&' with " | egrep -ni ")
CMD=$(echo $CMD | sed 's/&&/\" | egrep -ni \"/g')             

echo
echo "$CMD > $output"
eval "$CMD > $output"
if [[ "$?" == "0" ]]; then
	CMD="$(which notepadpp) \"$output\""
	echo "$CMD"
	eval "$CMD"
else
	echo -e $RED"Error while execution $CMD"$ATTR_RESET
fi
echo

