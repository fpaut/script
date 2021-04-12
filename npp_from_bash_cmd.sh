#/bin/bash
CMD="$1"
if [[ "$2" == "" ]]; then
	output="$HOME/npp.txt"
else
	output="$2"
	# Be sure output filename doesn't contains 
	# pipe '|' 
	output=$(echo "$output " | sed 's/|/_/g')
	# '&&' (replace it with '_' if any)
	output=$(echo "$output " | sed 's/&&/_/g')
	# '\' (replace it with '_' if any)
	output=$(echo "$output " | sed 's/\\/_/g')
	# ':' (replace it with '_' if any)
	output=$(echo "$output " | sed 's/:/_/g')
fi

[[ -f "$output" ]] && rm $output

# Replace '&&' with consecutive grep (replace '&&' with " | egrep -ni ")
echo "PWD=$(pwd)" > $output
echo "$CMD" >> $output
echo "" >> $output
CMD=$(echo $CMD | sed 's/&&/\" | egrep -ni \"/g')             

echo
echo "$CMD >> $output"
eval "$CMD >> $output"
ERR=$?
if [[ "$ERR" == "0" ]]; then
	NPPPATH="$(which notepadpp)"
	WINPATH="$(conv_path_for_win $output)"
	CMD="$NPPPATH \"$WINPATH\""
	echo "$CMD"
	eval $CMD
else
	echo -e $RED"Error while execution $CMD"$ATTR_RESET
fi
echo

