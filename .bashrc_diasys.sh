echo
echo -e $YELLOW"In BASHRC_DIASYS"$ATTR_RESET


export DEV_PATH="$ROOTDRIVE/e/dev/"
export BIN_PATH="$ROOTDRIVE/e/Tools/bin"
export SCRIPTS_PATH="$BIN_PATH/scripts"
export FIRMWARE_PATH="$DEV_PATH/STM32_Toolchain/dt-arm-firmware"
export TOOLS_PATH="$DEV_PATH/STM32_Toolchain/dt-fwtools"
export FSM_CYCLE="$FIRMWARE_PATH/ODS/FSM/Cycles/"

export INBOX_FILE="$ROOTDRIVE/c/Users/fpaut/AppData/Roaming/Thunderbird/Profiles/mtrhwyn5.default/ImapMail/mail2.diasys-technologies.com/INBOX"
export MAILBOX_TMP_FOLDER="$HOME/tmp/"
export MAILBOX_PREFIX="MAILBOX_"
export MAILBOX_POLLING_LOCK=$MAILBOX_PREFIX"POLLING_RUNNING"
export MAILBOX_POLLING_POPUP=$MAILBOX_PREFIX"POLLING_POPUP"

export DISPLAY=localhost:0.0
export LIBGL_ALWAYS_INDIRECT=1



alias cdd="popd 1>/dev/null; pushd $DEV_PATH 1>/dev/null"
alias cdf="popd 1>/dev/null; pushd $FIRMWARE_PATH 1>/dev/null"
alias cdfo="popd 1>/dev/null; pushd $FIRMWARE_PATH-other-branch 1>/dev/null"
alias cdfsm="cdf && cd ODS/FSM/Cycles"
alias cdjstest="cdf && cd Combo/Simul/Files/1/www/testscripts"
alias cdsch="cdf && cd Scheduling"
alias cdsimul="cdf && cd Combo/Simul/Files"
alias cds="popd 1>/dev/null; pushd $SCRIPTS_PATH 1>/dev/null"
alias cdt="popd 1>/dev/null; pushd $TOOLS_PATH 1>/dev/null"
alias cdto="popd 1>/dev/null; pushd $TOOLS_PATH-other-branch 1>/dev/null"
alias cmd="/mnt/c/WINDOWS/system32/cmd.exe /c"
alias jsd_copy="cdf \
				&& cp -v Combo/Simul/Files/0/schedule/iagan.jsd $ROOTDRIVE/n/Files/0/schedule \
				&& cp -v Combo/Simul/Files/0/schedule/iagan.jsn $ROOTDRIVE/n/Files/0/schedule \
				\\
				&& cdf && pushd SchedulerUnitTests/Test1 \
				&& cp -v ./IAtestdata.ana $ROOTDRIVE/m/respons/Tools/scripts/Test1/IAtestdata.ana.txt \
				&& popd
				"
alias jsd_from_gant="cdf && cd Scheduling && ./iagan.sh  && jsd_copy && popd 1>/dev/null"
				
#alias pdftk="java -jar /mnt/c/Users/fpaut/dev/Perso/pdftk/build/jar/pdftk.jar"
alias jenkins_CLI="java -jar jenkins-cli.jar -auth pautf:QtxS1204+ -s http://FRSOFTWARE02:8080/"

cmlog()
{
	cdlog 
	file=$1
	if [[ "$PATTERN" == "" ]]; 
	then 
		echo "Please, define PATTERN like PATTERN=\"MEAS_CYCLE|PROBE\""
		echo "You can define EXPATTERN to exlude some traces like EXPATTERN=\"\<MISC\>\""
		echo "A filename can be provided as first parameter"
		return
	else 
		# Get last file created in current folder
		set -- $(ls -t *) 
		# Update filename if not provided
		[[ "$file" == "" ]] &&  file=$1
##		rm ./filtered_$file
		if [[ "$EXPATTERN" == "" ]]; 
		then
			CMD="cat $file | egrep \"$PATTERN\" > ./filtered_$file"
		else
			CMD="cat $file | egrep \"$PATTERN\" | egrep -v \"$EXPATTERN\" > ./filtered_$file"
		fi
		echo $CMD && eval $CMD
		CMD="npp ./filtered_$file; "
		echo $CMD && eval $CMD
	fi
	cd -
}

cdlog()
{
	year=$(date +%Y)
	month=$(date +%m)
	day=$(date +%d)
	cd $(get_combo_log_folder)
}


copy_bin_to_msi()
{
	p1="$1"
	target="$2"
	ROOT_FOLDER=$(get_git_folder)/..
	export ROOT_FOLDER
	
	if [[ "$p1" == "" ]]; then
		echo "First parameter could contains ledappli, incubator, separator, measmeca, hydro1, hydro2, pmt, vcpF4, vcpGB (non HAL), vcpGB_HAL, vcppmt"
		echo "For many target, use '\"' like"
		echo "${FUNCNAME[0]} \"ledappli incubator separator measmeca hydro1 hydro2\""
		return 1
	fi
	if [[ "$target" == "" ]]; then
		echo; echo
		echo -e $CYAN"parameter #2 is the Main board target (IA, SA, CC)"
		echo -e "Default is 'IA'"$ATTR_RESET
		target="IA"
	fi
		
	
	DT_ARM_FIRMWARE="$DEV_PATH/STM32_Toolchain/dt-arm-firmware"
	
	if [[ "$(contains ledappli "$p1")" == "1" ]]; then
		echo -e $GREEN"LEDappli ($target) for Red Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/LEDappli/build/bin-spl_$target/LEDappli_$target.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/$target.bin"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains incubator "$p1")" == "1" ]]; then
		echo -e $GREEN"INCUBATOR.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_$target/INCUBATOR.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/INCUB.bin"; echo $CMD; $CMD
		
	fi
	if [[ "$(contains separator "$p1")" == "1" ]]; then
		echo -e $GREEN"SEPAR.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_$target/SEPARATOR.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/SEPAR.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains measmeca "$p1")" == "1" ]]; then
		echo -e $GREEN"MEASMECA.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_$target/MEASMECA.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/MEASM.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro1 "$p1")" == "1" ]]; then
		echo -e $GREEN"HYDRO1.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_$target/HYDRO1.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/HYDRO1.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro2 "$p1")" == "1" ]]; then
		echo -e $GREEN"HYDRO2.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_$target/HYDRO2.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/HYDRO2.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains pmt "$p1")" == "1" ]]; then
		echo -e $GREEN"PMT.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/PMTboardAppli/bin-spl_$target/PMTboardAppli.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/PMT.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcpF4 "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for Red Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binred-hal-f4/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/"; echo $CMD; $CMD
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binred-hal-f4/vcp_ext.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains vcpGB "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for Generic Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/bin-spl_$target/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC.bin"; echo $CMD; $CMD
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/bin-spl_$target/vcp_ext.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC_EXT.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcpGB_HAL "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp-HAL for Generic Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/bingen-hal-f4/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC-HAL.bin"; echo $CMD; $CMD
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/bingen-hal-f4/vcp_ext.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC-HAL_EXT.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcppmt "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for PMT Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binpmt/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPPMT.BIN"; echo $CMD; $CMD
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binpmt/vcp_ext.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPPMT_EXT.BIN"; echo $CMD; $CMD
	fi
	
}

copy_rawIpClient_to_medios_hp()
{
	cd $DEV_PATH/STM32_Toolchain/
	CMD="cp -f dt-fwtools/RuntimeFolderRelease/RawIpClient.exe $ROOTDRIVE/m/dev/rawIpClientScripts/"; echo $CMD; $CMD
	cd - 1>/dev/null
}

copy_rawIpClientScript_to_medios_hp()
{
	cd $DEV_PATH/STM32_Toolchain/
	CMD="rm -rf $ROOTDRIVE/m/dev/rawIpClientScripts/*"; echo $CMD; $CMD
	CMD="cp -rf ./rawIpClientScripts/* $ROOTDRIVE/m/dev/rawIpClientScripts"; echo $CMD; $CMD
	CMD="cp -f dt-fwtools/RuntimeFolderRelease/RawIpClient.exe $ROOTDRIVE/m/dev/rawIpClientScripts/"; echo $CMD; $CMD
	CMD="rm -f $ROOTDRIVE/m/dev/rawIpClientScripts/Update_RawIpClient.ps1"; echo $CMD; $CMD
	cd - 1>/dev/null
}

copy_web_pages_to_medios_hp()
{
	CMD="cp -vr $DEV_PATH/STM32_Toolchain/dt-arm-firmware/Combo/Simul/Files/1/www/* $ROOTDRIVE/m/ComboMaster/emulated-disk/Files/1/www/"
	echo $CMD; $CMD
}

dbg_count_incub_action()
{
	while true
	do
		ERR=0
		date
		LOGFILE="./$(get_combo_last_log_name .)"
		cat $LOGFILE 2>&1 1>/dev/null
		ERR=$?
		if [[ "$ERR" == "0" ]]; then
			CLEAR_COUNT=$(cat $LOGFILE 2>/dev/null | grep "Incubator_ClearInstructions" | wc -l)
			ADD_COUNT=$(cat $LOGFILE 2>/dev/null | grep ") AddMove(" | wc -l)
			RUN_COUNT=$(cat $LOGFILE 2>/dev/null | grep "Incubator_RunInstructions" | wc -l)
			echo "LOGFILE= "$LOGFILE
			echo -n "Clear:"$CLEAR_COUNT" Add:"$ADD_COUNT" Run:"$RUN_COUNT
			echo
			echo ERR=$ERR; echo
			if [[ "$CLEAR_COUNT" != "$RUN_COUNT" ]]; then
				if [[ "ERR" == "0" ]]; then
					break
				fi
			fi
		fi
		sleep 3
	done
	echo
	# 0000_ for alphabetical sorting and avoiding 'get_combo_last_log_name()' to get this file as "last log name"
	CMD="cp -v $LOGFILE 0000_BUG_${LOGFILE#*/}"; echo -n "COPY "; eval "$CMD"
	echo
}

dbg_count_dev_action()
{
	if [[ "$#" < 1 ]]; then
		echo "#1 is logfile"
		echo "#2 = true to exit on error"
		return 1
	fi
	LOGFILE="$1"
	EXIT_ON_ERROR="$2"
	ERR_COUNT=false
	NBERR_COUNT=0
	TEST=$(cat $LOGFILE 2>/dev/null)
	[[ "$?" != "0" ]] && echo "$LOGFILE inaccessible" && return 0
	LOG_CONTENT=$(cat $LOGFILE)
	echo LOG= $LOGFILE \-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-
	for dev in reaarm reatr separ meas incub samarm cuvload
	do
		SCH_COUNT=$(echo -e "$LOG_CONTENT" | grep SCHMaster | grep "\\\\\\\"dev\\\\\\\":\\\\\\\"$dev\\\\\\\"" | wc -l)
		PARSED_COUNT=$(echo -e "$LOG_CONTENT" | grep "cb_parse_$dev" | wc -l)
		EXEC_COUNT=$(echo -e "$LOG_CONTENT" | grep "SCHMain_OrderExec" | grep "$dev" | wc -l)
		
		if [[ "$SCH_COUNT" != $PARSED_COUNT || $SCH_COUNT != $EXEC_COUNT || $EXEC_COUNT != $PARSED_COUNT ]]; then
			echo -e $RED"Error!"$ATTR_RESET
			echo -e "$LOG_CONTENT" | grep time |  sed -e 1b -e '$!d'
			ERR_COUNT=true
		fi
		if [[ "$ERR_COUNT" != "false" ]]; then		
			LOG_COLOR=$RED
			NBERR_COUNT=$(($NBERR_COUNT + 1))
		else
			LOG_COLOR=$GREEN
		fi
		echo -e  "dev $LOG_COLOR\"$dev\"$ATTR_RESET \t $LOG_COLOR$SCH_COUNT$ATTR_RESET frames sent, \t $LOG_COLOR$PARSED_COUNT$ATTR_RESET parsed, \t $LOG_COLOR$EXEC_COUNT$ATTR_RESET executed"
		ERR_COUNT=false
	done
	echo -e "$LOG_CONTENT" | grep time |  sed -e 1b -e '$!d'
	echo
	if [[ "$NBERR_COUNT" != "0" && "$EXIT_ON_ERROR" == "true" ]]; then
		return 1
	fi
}


deg_to_step()
{
	deg=$1
	echo $(( $(($((600 * $deg)) / 360)) )) steps
	echo $(( $(($((600 * $deg)) / 360)) * 4)) 1/4 steps
}


get_combo_last_log_name()
{
	if [[ "$1" == "" ]]; then
		DIR=($(ls $(get_combo_log_folder ) | grep "\.LOG") )
	else
		DIR=($(ls "$1"))
	fi
	nbLog=${#DIR[@]}
	lastArrayIndex=$(echo $(( $nbLog - 1)))
	lastLog=$(echo ${DIR[$lastArrayIndex]})
	echo $lastLog
}

get_combo_last_log_path()
{
	echo $(get_combo_log_folder)/$(get_combo_last_log_name)
}

get_combo_log_folder()
{
	logPath="$(get_git_folder)/../Combo/Simul/Files/0/logs/"
	ERR=$?
	if [[ "$ERR" == "0" ]]; then
		DIR=($(ls $logPath) )
		nbLog=${#DIR[@]}
		lastArrayIndex=$(echo $(( $nbLog - 1)))
		lastDir=$(echo ${DIR[$lastArrayIndex]})
		dirOk=0
		while [[ "$dirOk" != "1" ]]
		do
			if [[ "${lastDir:0:1}" -gt 0 ]] && [[ "${lastDir:0:1}" -lt 9 ]];
			then
				dirOk=1
			else 
#				echo -n lastArrayIndex=$lastArrayIndex \-\> >&2
				lastArrayIndex=$(($lastArrayIndex - 1))
#				echo $lastArrayIndex >&2
				lastDir=$(echo ${DIR[$lastArrayIndex]})
			fi
		done
		echo $logPath$lastDir
	else
		echo "Not in firmware folder"
		return $ERR
	fi
}

get_version()
{
	version=$(cat $FIRMWARE_PATH/ODS/LEDappli/version.c | grep FIRMWARE_VERSION)
	version=${version#*\"}
	version=${version%\"*}
	echo $version
}


ledappli_clean()
{
	pushd $FIRMWARE_PATH/ODS/LEDappli
	make clean
	popd
}

ledappli_make()
{
	targetList="$@"
	if [[ "$targetList" == "" ]]; then
	echo; echo
		echo -e $CYAN"First parameter is the Main board target (IA, SA, CC)"
		echo -e "Default is 'IA'"$ATTR_RESET
		targetList="IA"
	fi
	pushd $FIRMWARE_PATH/ODS/LEDappli
	for target in $targetList
	do
		CMD="make BOARD=STM32P405_HAL MODULE=$target DEBUG=TRUE SHOW_GCC=0"
		echo; echo -e $YELLOW$CMD$ATTR_RESET; echo; $CMD
		copy_bin_to_msi ledappli "$target"
	done
	echo; read -t 2 -p "Appuyez sur entrée... "
	popd
}

npp() {
    CMD="/mnt/e/Tools/Notepad++/notepad++.exe \"$(conv_path_for_win $@)\""
    echo $CMD
	eval "$CMD" 2>/dev/null&
}

ganttproject()
{
	path="$1"
	CMD="/mnt/e/Tools/GanttProject/ganttproject.exe $(wslpath -w $path)"
	echo $CMD
	$CMD&
}

mailbox_check() {
	prev="$1"
	actual="$(mailbox_get_info)"; 
	ls "$$MAILBOX_TMP_FOLDER""MAILBOX_POLLING_POPUP $MAILBOX_POLLING_PID" 2>/dev/null
	if [[ "$?" != "0" ]]; then
		if [[ "$prev" != "$actual" ]]; then 
			if [[ "$prev" > "$actual" ]]; then 
				# cp $INBOX_FILE "$INBOX_FILE"".back"
				# diff $INBOX_FILE "$INBOX_FILE"".back" >/dev/stderr
				echo Diff detected prev=$prev actual=$actual... >/dev/stderr
			fi
			touch "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_POPUP $MAILBOX_POLLING_PID"
			notify-send " .. NEW MAIL! .. "
##			zenity --info --text="prev=$prev actual=$actual" 2>/dev/null
			rm "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_POPUP $MAILBOX_POLLING_PID" 2>/dev/null
		fi
	fi
	echo "$actual"
}

mailbox_clean_lock_files() {
	CMD="rm -v \"$MAILBOX_TMP_FOLDER$MAILBOX_PREFIX\"* 2>/dev/null"
	echo $CMD
	eval $CMD
}

mailbox_get_info() {
	# Return size in byte of the mailbox file
	echo $(stat --printf="%s" $INBOX_FILE)
}


mailbox_polling() {
	prev=$(mailbox_get_info)
	while (true) do 
##		echo "before prev=$prev"
		prev=$(mailbox_check "$prev")
##		echo "after mailbox_check prev=$prev"
		sleep 10; 
	done
}

mailbox_kill_polling() {
	echo Killing process $MAILBOX_POLLING_PID
	kill $MAILBOX_POLLING_PID
	mailbox_clean_lock_files
}

myMount()
{
	drive=$1
	# Lowercase
	letter=${drive,,}
	# Uppercase
	LETTER=${drive^^}
	
	echo ls /mnt/$letter/
	already_mounted=$(ls /mnt/$letter/)
	if [[ "$already_mounted" == "" ]]; then
		TEST_MOUNT="powershell.exe ls '$LETTER:\\' 2>/dev/null 1>/dev/null"
		eval $TEST_MOUNT
		ERR=$?
		if [[ "$ERR" == "0" ]]; then
			echo $LETTER:\ exists! Attempts to mount letter $LETTER: to /mnt/$letter
			sudo mkdir -p /mnt/$letter
			CMD="sudo mount -t drvfs $LETTER: -o umask=000 /mnt/$letter"
			$CMD
			ERR=$?
			if [[ "$ERR" == "0" ]]; then
				echo -e $GREEN"success!"$ATTR_RESET
			else
				echo -e $RED"failed!"$ATTR_RESET
			fi
		else
			echo $LETTER:\ is not a known drive for Windows
		fi
	else
		echo "/mnt/$letter/ already mounted in WSL"
	fi
}

notify-send() {
	powershell.exe "New-BurntToastNotification -Text \"$1\"" 2>&1 1>/dev/null
}

on_shell_exit() {
	echo on_shell_exit
	mailbox_kill_polling
}

pdftk() {
	files="$@"
	java -jar /mnt/c/Users/fpaut/dev/Perso/pdftk/build/jar/pdftk.jar $files
}

####################################################################################################
# Parse a line read in a Scheduler Log file, and determine which COMM is used
sch_get_comm()
{
	line="$1"
	if [[ "$(echo "$line" | grep \\\[IA1\\\])" != "" ]]; then
		echo "ia.1"
	elif [[ "$(echo "$line" | grep \\\[IA2\\\])" != "" ]]; then
		echo "ia.2"
	elif [[ "$(echo "$line" | grep \\\[SA\\\])" != "" ]]; then
		echo "sa"
	elif [[ "$(echo "$line" | grep \\\[CC1\\\])" != "" ]]; then
		echo "cc.1"
	elif [[ "$(echo "$line" | grep \\\[CC2\\\])" != "" ]]; then
		echo "cc.2"
	fi
}

####################################################################################################
# Parse a Scheduler Log file, and extract Scheduler frame file
sch_extract_frames()
{
	if [[ "$#" -le "1" ]]; then
		echo "Parse a Scheduler Log file, and extract Scheduler frame file"
		echo "#1 is the logfile"
		echo "#2 is the related module (eg.: "[IA1]"|"[IA2]"|"[SA]"|"[CC1]"|"[CC2]")"
		echo "#3 is additionnal filters (eg.: "reaarm"|"samarm"|"reatr"|"samtr")"
		echo "#4 is the destination path"
		echo 
		echo "eg.: sch_extract_frames \"./093441.LOG\"  \"[IA1]|[SA]" "reaarm|samarm\" \"path/to/output\""
		return
	fi
	NB_FRAME=0
	logfile="$1"
	module="$2"
	addFilter="$3"
	destPath="$4"
	if [[ "$destPath" == "" ]]; then
		destPath = "$HOME"
	fi
	mkdir -p $destPath
	cp -f $logfile $destPath
	logfile_name=${logfile##*/}
	logfile_without_ext=${logfile_name%.*}
	logfile_ext=${logfile_name##*.}
	output_frames_1=$HOME/SCH_Frames_1.txt
	final_output_frames="$destPath/"
	final_output_frames=$final_output_frames"$logfile_without_ext"
	if [[ "$addFilter" != "" ]]; then
		search='|'
		replace='_'
		add_to_filename=$(echo $addFilter | sed "s,$search,$replace,g")
		final_output_frames=$final_output_frames"_$add_to_filename"
	fi
	final_output_frames=$final_output_frames"_SCH_Frames.txt"
	  
	#Before continue, checks errors found
	echo "cat $logfile | grep 'ERROR\:'"
	ERROR_FOUND=$(cat $logfile | egrep 'ERROR\:')
	if [[ "$ERROR_FOUND" != "" ]]; then
		echo -e $CYAN"ERRORS FOUND! :"$RED
		cat $logfile | egrep 'ERROR\:'
		echo -e $CYAN
		read -e -i "N" -p "Continue? ( (Y)es / (n)o : "
		if [ "$REPLY" != "y" ] && [ "$REPLY" != "Y" ]; then
			return 0
		fi
		echo -e $ATTR_RESET
	fi
		
	# Keep only frames & line with VAR
	echo -e $GREEN"Extracting lines with frame in $output_frames_1" $ATTR_RESET
	FILTER_FRAME_SENT="]\ ->\ {"
	FILTER_VAR="VAR;"
	MODULE_FILTER="$module"
	# for grep, replace "[" BY "\[" and "]" BY "\]"
	search='\['
	replace='\\\['
	MODULE_FILTER=$(echo $MODULE_FILTER | sed "s,$search,$replace,g")
	search='\]'
	replace='\\\]'
	MODULE_FILTER=$(echo $MODULE_FILTER | sed "s,$search,$replace,g")
	addFilter=$addFilter"|""\\\\\"type\\\\\" : \\\\\"begin\\\\\""
	addFilter=$addFilter"|""\\\\\"type\\\\\" : \\\\\"end\\\\\""
	addFilter=$addFilter"|""\\\\\"type\\\\\" : \\\\\"cancelRun\\\\\""
	CMD="cat $logfile | egrep '$FILTER_FRAME_SENT|$FILTER_VAR'| egrep '$FILTER_VAR|$MODULE_FILTER' | egrep '$FILTER_VAR|$addFilter' > $output_frames_1"
	echo $CMD
	eval $CMD
	echo -e $GREEN"$output_frames_1 done!" $ATTR_RESET
	NB_LINES=$(cat $output_frames_1 | wc -l)
	
	echo -e $GREEN"Reparse $output_frames_1 to: "
	echo -e '- Replace \" by "'
	echo -e '- Replace { "fct" by {"id":"880","com":"immu.1","fct"'
	echo -e '- Removing prefix log part {"time":"2021/02/04 09:05:21 (...) ] -> {'
	echo -e '- Remove ending "}'
	echo -e '- Replace (...)VAR; by <'
	echo -e "and store final output in"$BLUE $final_output_frames $ATTR_RESET
	echo -e $GREEN"\n\nParsing and extracting $(cat $logfile | wc -l) lines...\n\n"$ATTR_RESET
	
	LINE_NUMBER=1
	if [[ -f "$final_output_frames" ]]; then
		rm -rf $final_output_frames
	fi

	# save cursor position
	cursor_pos_save
	
	FILTER_FRAME_SENT="]\ ->\ {"
	FILTER_VAR="VAR;"
	cat $output_frames_1 | while read line
	do
		# restore cursor position
		cursor_pos_rest
		
		NB_FRAME=$(($NB_FRAME + 1))
		PERCENT=$((100 * $LINE_NUMBER))
		PERCENT=$(($PERCENT / $NB_LINES))
		echo -en "$NB_FRAME frames - $PERCENT%"
		LINE_NUMBER=$(($LINE_NUMBER + 1))
		# Replace \" BY "
		search='\\\\\\\"'
		replace='\"'
		line=$(echo $line | sed "s,$search,$replace,g")

		# Replace [{ "fct"] BY [{"id":"880","com":"immu.1","fct"]
		search='{ \"fct\"'
		COMM=$(sch_get_comm "$line")
		replace="{\"id\":\"880\"\,\"com\":\"$COMM\"\,\"fct\""
		line=$(echo $line | sed "s,$search,$replace,g")
		
		# Remove prefix log part {"time":"2021/02/04 09:05:21 (...) ] -> {
		sep='] ->'
		line=$(echo ${line#*$sep})
		
		# Remove ending "}
		sep='}"}'
		rep='};50;'
		line=${line//$sep/$rep}

		# Insert Line with WARNING
		search='WARNING:'
		WARNING=$(echo $line | grep "$search")
		if [[ "$WARNING" != "" ]]; then 
			echo -e $CYAN" WARNING found!"$ATTR_RESET
			line="<$(echo $search ${line##*$search})"
			line="$(echo  ${line%\'*})"
		fi
				
		# Insert some line with ERROR
		search="ERROR:"
		ERROR=$(echo $line | grep SCHMaster | grep "$search")
		if [[ "$ERROR" != "" ]]; then 
			echo -e $RED" ERROR found!"$ATTR_RESET
			line=${line##*$search}
			line="<$(echo $search ${line#*)})"
			line="$(echo  ${line%\'*})"
		fi
				
		# Replace (...)VAR; BY <
		search='VAR;'
		TO_LOG=$(echo $line | grep "$search")
		if [[ "$TO_LOG" != "" ]]; then 
			line="<$(echo ${line#*VAR;})"
			line="$(echo  ${line%;*})"
		fi
		
		echo $line >> $final_output_frames
	done
	
	echo "<END OF SCRIPT!" >>  $final_output_frames
	echo -e $GREEN" Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
}

sch_extract_frames_V1()
{
	if [[ "$#" -le "1" ]]; then
		echo "Parse a Scheduler Log file, and extract Scheduler frame file"
		echo "#1 is the logfile"
		echo "#2 is the destination path"
		return
	fi
	logfile=$1
	destPath=$2
	if [[ "$destPath" == "" ]]; then
		destPath = "$HOME"
	fi
	logfile_without_ext=${logfile%.*}
	logfile_ext=${logfile##*.}
	output_frames_1=$HOME/SCH_Frames_1.txt
	output_frames_2=$HOME/SCH_Frames_2.txt
	output_frames_3=$HOME/SCH_Frames_3.txt
	output_frames_4=$HOME/SCH_Frames_4.txt
	output_frames_5=$HOME/SCH_Frames_5.txt
	output_frames_6=$HOME/SCH_Frames_6.txt
	final_output_frames="$destPath/$logfile_without_ext"_SCH_Frames.txt
	
	# Keep only frames
	echo -e $GREEN"Extracting lines with frame" $ATTR_RESET
	FILTER_FRAME_SENT="]\ ->\ {"
	FILTER_VAR="VAR;"
	CMD="cat $logfile | egrep '$FILTER_FRAME_SENT|$FILTER_VAR' > $output_frames_1"
	echo $CMD; eval $CMD
	echo -e $GREEN"$output_frames_1 done!" $ATTR_RESET
	
	# Replace \" by "
	search='\\\\\\\"'
	replace='\"'
	echo -e $GREEN'Replace \" by "' $ATTR_RESET
	CMD="cat $output_frames_1 |  sed \"s,$search,$replace,g\" "
	echo $CMD; eval $CMD | tee $output_frames_2 | tee /dev/null
	echo -e $GREEN"$output_frames_2 done!" $ATTR_RESET
	
	# Replace [{ "fct"] by [{"id":"880","com":"immu.1","fct"]
	search='{ \"fct\"'
	replace='{\"id\":\"880\"\,\"com\":\"immu.1\"\,\"fct\"'
	echo -e $GREEN'Replace { "fct" by {"id":"880","com":"immu.1","fct"' $ATTR_RESET
	CMD="cat $output_frames_2 |  sed \"s,$search,$replace,g\""
	echo $CMD; eval $CMD | tee $output_frames_3 | tee /dev/null
	echo -e $GREEN"$output_frames_3 done!" $ATTR_RESET
	
	# Remove prefix log part {"time":"2021/02/04 09:05:21 (...) ] -> {
	rm $output_frames_4
	echo -e $GREEN'Removing prefix log part {"time":"2021/02/04 09:05:21 (...) ] -> {' $ATTR_RESET
	sep='] ->'
	cat $output_frames_3 | while read line
	do
		echo ${line#*$sep} >> $output_frames_4
	done
	echo -e $GREEN"$output_frames_4 done!" $ATTR_RESET
	
	# Remove ending "}
	rm -f $output_frames_5
	echo -e $GREEN'Removing ending "}' $ATTR_RESET
	sep='}"}'
	rep='};50;'
	cat $output_frames_4 | while read line
	do
		echo ${line//$sep/$rep} >> $output_frames_5
	done
	
	# Replace (...)VAR; by <
	rm -f $output_frames_6
	echo -e $GREEN'Replace (...)VAR; by <' $ATTR_RESET
	search='VAR;'
	cat $output_frames_5 | while read line
	do
		# Check COMM of some device
		TO_LOG=$(echo $line | grep "$search")
		if [[ "$TO_LOG" != "" ]]; then 
			line="<$(echo ${line#*VAR;})"
			line="$(echo  ${line%;*})"
			echo $line >> $output_frames_6
		else
			echo $line >> $output_frames_6
		fi
	done
	
	# Replace "end"}};50; by "end"}};;
	rm -vf $final_output_frames
	search='\"end\"}};50;'
	replace='\"end\"}};;'
	echo -e $GREEN"Replace $search by $replace" $ATTR_RESET
	CMD="cat $output_frames_6 |  sed \"s,$search,$replace,g\" "
	echo $CMD; eval $CMD | tee $final_output_frames | tee /dev/null
	echo -e $GREEN"$final_output_frames done!" $ATTR_RESET
	
	echo "<END OF SCRIPT!" >>  $final_output_frames
	echo -e $GREEN"Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
}
####################################################################################################
# Parse frame file, and set Scheduler end frame ("fct":{"name":"IAsched", "type" : "end"}};;) with a
# specified timeout
sch_set_end_timeout()
{
	if [[ "$#" -le "1" ]]; then
		echo "Parse frame file, and set Scheduler end frame (\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}};;)"
		echo "with a specified timeout"
		echo "#1 is the logfile"
		echo "#2 is the timeout value"
		return
	fi
	logfile=$1
	tmp_file="$HOME/tmp.txt"
	timeout_value=$2

	# Replace "end"}};; by "end"}};$timeout_value;
	rm $tmp_file
	search="\\\"end\\\"}};50;"
	replace="\\\"end\\\"}};$timeout_value;"
	echo -e $GREEN"Replace $search by $replace" $ATTR_RESET
	echo search=$search
	echo replace=$replace
	CMD="cat $logfile |  sed \"s,$search,$replace,g\"  | tee $tmp_file"
	echo $CMD; eval "$CMD"
	rm -f $logfile
	mv -f $tmp_file $logfile"_TO_"$timeout_value
	echo -e $GREEN"$logfile done!" $ATTR_RESET
	
	echo -e $GREEN"Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
}

####################################################################################################
# Parse frame file, and generate a new file on each "fct":{"name":"IAsched", "type" : "end"}} found
sch_split_frame_file()
{
	if [[ "$#" -lt "1" ]]; then
		echo "Number of parameters = $#"
		echo "Parse frame file, and generate a new file on each (\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}};;) found"
		echo "#1 is the frame file"
		echo "  Each new file generated is named '#1__Cycle_\index_file\.txt'"
		return
	fi
	logfile=$1
	logfile_without_ext=${logfile%.*}
	TMP_TRASH="$(dirname $logfile)/TO_DELETE"
	mkdir -p $TMP_TRASH

	# search end frame  ("\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}")
	index_file=1
	final_output_frames="$logfile_without_ext""_Cycle_"$(printf "%03d" $((10#$index_file)))".txt"
	search_next_cycle=$false
	if [[ -e "$final_output_frames" ]]; then
		mv -f $final_output_frames $TMP_TRASH
	fi
	echo "Generate "$final_output_frames
	NB_LINE=0
	cat $logfile | while read line
	do
		search="\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}"
		END=$(echo $line | grep "$search")
		NB_LINE=$(($NB_LINE + 1))
		search="\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}|\"fct\":{\"name\":\"IAsched\", \"type\" : \"cancelRun\"}}"
		END=$(echo $line | egrep "$search")
		if [[ "$END" != "" && "$search_next_cycle" == "$false" ]]; then
			search_next_cycle=$true
			echo -n "Searching next cycle..."
		fi
		if [[ "$END" == "" && "$search_next_cycle" == "$true" ]]; then
			echo "found!"
			search_next_cycle=$false
			echo $final_output_frames" ended ($NB_LINE lines)"
			if [[ "$NB_LINE" -lt 3 ]]; then
				echo "Empty file NB_LINE=$NB_LINE"
				rm $final_output_frames
			fi
			NB_LINE=0
			index_file=$(($index_file + 1))
			final_output_frames="$logfile_without_ext""_Cycle_"$(printf "%03d" $((10#$index_file)))".txt"
			if [[ -e "$final_output_frames" ]]; then
				mv -f $final_output_frames $TMP_TRASH
			fi
			echo "Generate "$final_output_frames
		fi
		
		echo $line >> $final_output_frames
		echo -n "-"
	done
	echo -e $GREEN"\nDone! (from $logfile)"
	echo $BLUE
	eval "ls -halF "$logfile_without_ext""_Cycle_""*""
	echo $ATTR_RESET
}

sch_split_frame_file_V1()
{
	if [[ "$#" -lt "1" ]]; then
		echo "Number of parameters = $#"
		echo "Parse frame file, and generate a new file on each (\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}};;) found"
		echo "#1 is the frame file"
		echo "  Each new file generated is named '#1__Cycle_\index_file\.txt'"
		return
	fi
	logfile=$1
	logfile_without_ext=${logfile%.*}
	TMP_TRASH="$(dirname $logfile)/TO_DELETE"
	mkdir -p $TMP_TRASH

	# search end frame  ("\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}")
	index_file=001
	final_output_frames="$logfile_without_ext""_Cycle_"$index_file".txt"
	next_output_frames="$logfile_without_ext""_Cycle_"$(($index_file + 1))".txt"
	search_next_cycle=$false
	if [[ -e "$final_output_frames" ]]; then
		mv -f $final_output_frames $TMP_TRASH
	fi
	echo "Generate "$final_output_frames
	NB_LINE=0
	cat $logfile | while read line
	do
		echo $line >> $final_output_frames
		NB_LINE=$(($NB_LINE + 1))
		search="\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}"
		END=$(echo $line | grep "$search")
		if [[ "$END" != "" ]]; then
			echo "End of Generate "$final_output_frames
			if [[ "$NB_LINE" -lt 3 ]]; then
				echo "Empty file NB_LINE=$NB_LINE"
				rm $final_output_frames
			fi
			index_file=$(printf "%03d" $((10#$index_file + 1)))
			final_output_frames="$logfile_without_ext""_Cycle_"$index_file".txt"
			if [[ -e "$final_output_frames" ]]; then
				mv -f $final_output_frames $TMP_TRASH
			fi
			echo "Generate "$final_output_frames
			NB_LINE=0
		fi
	done
	echo -e $GREEN"Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
}

send_folder_to_ComboMaster()
{
	ip="$1"
	to="$2"
	if [[ "$#" < 1 ]]; then
		echo "#1 is the IP of ComboMaster"
		echo "#2 (optionnal) is the time out to wait between to sending frame"
		return 1
	fi
	if [[ "$to" == "" ]]; then
		to=50
	fi
	
	ls * | while read file
	do
		echo -e $CYAN$file$ATTR_RESET
		CMD="send_to_ComboMaster 127.0.0.1 $file $to | egrep \"Sending|Receive\""
		echo $GREEN$CMD$ATTR_RESET
		eval $CMD
	done
}

send_to_ComboMaster()
{
	ip="$1"
	file="$2"
	to="$3"
	if [[ "$#" < 2 ]]; then
		echo "#1 is the IP of ComboMaster"
		echo "#2 is the file to send to ComboMaster"
		echo "#3 (optionnal) is the time out to wait between to sending frame"
		return 1
	fi
		
	CMD="/mnt/e/dev/STM32_Toolchain/dt-arm-firmware/Tools/RawIpClient/RawIpClient.exe --ip $ip --rwc "$file" --to $to"
	echo "$CMD"
	eval "$CMD"
}


step_to_deg()
{
	step=$1
	echo $(( $(($step * 360)) / 600 ))° if steps is 1/1 steps
	echo $(($(($step * 360)) / $((600 * 4)) ))° if steps is 1/4 steps
}

update_repo()
{
	
	MasterBranch="master"
	UpstreamBranch="Fred"
	wip_branch=$1
	if [[ "$wip_branch" == "" ]]; then
		echo "First parameter is the 'Work In Progress' branch name"
		read -e -i 'Y' -p "Using '$GREEN$BRANCH$ATTR_RESET' as 'Work In Progress' branch name? (Y/n): "
		if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
			wip_branch=$BRANCH
		else
			return
		fi
	fi
	
	uncommited=$(git status -s | grep --color=always " M " | grep -v "version")
	if [[ "$uncommited" != "" ]]; then
		echo "Theses files are modified but not commited."
		echo -e "$uncommited"
		read -e -i 'Y' -p "Do you want to commit before? (Y/n): "
		if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
			return 1
		fi
	fi

	SVG_NAME="_WIP_"
	SVG_NAME+="$FUNCNAME"
	SVG_NAME+="_$wip_branch"

	
	CMD="git co $wip_branch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="yes | git_st_rm $SVG_NAME"; echo -e $CYAN$CMD$ATTR_RESET; eval "$CMD"
	CMD="yes n | git_st_save $SVG_NAME"; echo -e $CYAN$CMD$ATTR_RESET; eval "$CMD"
	CMD="git co $MasterBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git pull -X theirs origin/$MasterBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git co $UpstreamBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git rebase --strategy-option theirs $MasterBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git co $wip_branch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git rebase --strategy-option theirs $MasterBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	read -e -i 'C' -p "Restore saved files, or Compare ? (R/C): "
	if [[ "$REPLY" == "R" || "$REPLY" == "R" ]]; then
		CMD="git_st_restore $SVG_NAME"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	else
		CMD="git_st_cmp $SVG_NAME"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	fi
	
	if [[ "$(pwd | grep \"dt-arm-firmware\")" != "" ]]; then
		echo -e $CYAN"TO DO:"$ATTR_RESET
		CMD="make BOARD=STM32P405 SHOW_GCC=0 clean"; echo -e $CYAN$CMD$ATTR_RESET
		CMD="make BOARD=STM32P405 SHOW_GCC=0"; echo -e $CYAN$CMD$ATTR_RESET
		CMD="make BOARD=GENERIC_BOARD_NEW  GB=MEASMECA SHOW_GCC=0 clean"; echo -e $CYAN$CMD$ATTR_RESET
		CMD="make BOARD=GENERIC_BOARD_NEW  GB=MEASMECA SHOW_GCC=0"; echo -e $CYAN$CMD$ATTR_RESET
		echo -e $CYAN$CMD$ATTR_RESET
	fi
}


upstream_repo()
{
	UpstreamBranch="Fred"
	wip_branch=$1
	if [[ "$wip_branch" == "" ]]; then
		echo "First parameter is the 'Work In Progress' branch name"
		read -e -i 'Y' -p "Using '$GREEN$BRANCH$ATTR_RESET' as 'Work In Progress' branch name? (Y/n): "
		if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
			wip_branch=$BRANCH
		else
			return
		fi
	fi
	CMD="git co $wip_branch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git ss"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git co $UpstreamBranch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git pull"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git merge $wip_branch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git push"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git co $wip_branch"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
	CMD="git sp"; echo -e $CYAN$CMD$ATTR_RESET; $CMD
}

vcp_clean() 
{
	popd
	pushd $FIRMWARE_PATH/ODS/vcp
	make clean
	popd
}

vcp_make()
{
	popd
	pushd $FIRMWARE_PATH/ODS/vcp
	make BOARD=STM32P405_HAL MODULE=IA
	copy_bin_to_msi vcpF4 IA
	echo
	read -t 5 -p \"Appuyez sur entrée... \"
	popd
}


wedit() {
	filepath="$1"
	if [[ "${filepath:0:1}" != "." ]]; then
		if [[ -e "./$1" ]]; then
			filename="./$1"
		fi
	fi
	local path=$(which "$filepath" 2>/dev/null)
	CMD="npp \"$path\""; echo $CMD; 
	if [[ "$filepath" != "" && "$path" == "" ]]; then
		return 0
	fi
	
	eval "$CMD"
}

cd $SCRIPTS_PATH
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "my scripts\t: $FILEMODE"
cd - 1>/dev/null
cd $DEV_PATH/STM32_Toolchain/dt-arm-firmware
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-arm-firmware\t: $FILEMODE"
cd - 1>/dev/null
cd $DEV_PATH/STM32_Toolchain/dt-fwtools
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-fwtools\t: $FILEMODE"
cd - 1>/dev/null


which() {
	who="$@"
	
#	first_path_letter=${who:0:1}
	
	paths=($(eval "/bin/which -a $who" 2>/dev/null))
	ERR=$?
	
 	if [[ "$paths" == "" ]]; then
		paths="$who"
	fi
 	if [[ "$ERR" == "0" ]]; then
        echo "${paths[$((${#paths[@]} - 1))]}"
        ERR=$?
	else
		echo -e "Error $ERR on which $who" > /dev/stderr
        echo "${paths[$((${#paths[@]} - 1))]}"
    fi
}


myMount F
myMount M
myMount N
myMount Z
myMount G

CMD="ls $MAILBOX_TMP_FOLDER | grep $MAILBOX_POLLING_LOCK 2>/dev/null"
eval $CMD
if [[ "$?" != "0" ]]; then
	echo "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_LOCK" not found
	mailbox_clean_lock_files
	trap on_shell_exit EXIT
	echo Launching Mailbox polling
	rm "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_LOCK" 2>/dev/null
	rm "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_POPUP" 2>/dev/null
	mailbox_polling&
	MAILBOX_POLLING_PID="$!"
	touch "$MAILBOX_TMP_FOLDER""$MAILBOX_POLLING_LOCK $MAILBOX_POLLING_PID"
else
	echo Mailbox polling not launched
fi
echo MAILBOX_POLLING_PID= $MAILBOX_POLLING_PID

echo -e $YELLOW"Out of BASHRC_DIASYS"$ATTR_RESET
