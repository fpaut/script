jsonCmd="X"
while [[ "$jsonCmd" != "" ]]
do
	JSON=("get-log-level-list 0")
	JSON+=("apply-evt EVT_PB_NEXT_STATE")
	JSON+=("set-condition 0")
	JSON+=("set-condition 1")
	JSON+=("help 0")

	echo "zenity --list --height=$((${#JSON[@]} * 50)) --column=Command \"${JSON[@]}"
	jsonCmd=$(zenity --list --height=$((${#JSON[@]} * 50)) --column=Command "${JSON[@]}")
	
	if [[ "$jsonCmd" == "" ]]; then
		exit 2
	fi
	jsonCmd=${jsonCmd//#/ }
	CMD="timeout 5 ComboConsole.exe noboot=true host=\"127.0.0.1\" com=\"1\" command=\"fsm $jsonCmd\""
	echo $CMD
	eval $CMD
done