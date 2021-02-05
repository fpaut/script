echo
echo In BASHRC_DIASYS

DEV_PATH="$ROOTDRIVE/e/dev/"
BIN_PATH="$ROOTDRIVE/e/Tools/bin"
SCRIPTS_PATH="$BIN_PATH/scripts"
FIRMWARE_PATH="$DEV_PATH/STM32_Toolchain/dt-arm-firmware"
TOOLS_PATH="$DEV_PATH/STM32_Toolchain/dt-fwtools"
FSM_CYCLE="$FIRMWARE_PATH/ODS/FSM/Cycles/"

INBOX_FILE="$ROOTDRIVE/c/Users/fpaut/AppData/Roaming/Thunderbird/Profiles/mtrhwyn5.default/ImapMail/mail2.diasys-technologies.com/INBOX"
MAILBOX_TMP_FOLDER="$HOME/tmp/"
MAILBOX_PREFIX="MAILBOX_"
MAILBOX_POLLING_LOCK=$MAILBOX_PREFIX"POLLING_RUNNING"
MAILBOX_POLLING_POPUP=$MAILBOX_PREFIX"POLLING_POPUP"

export DISPLAY=localhost:0.0
export LIBGL_ALWAYS_INDIRECT=1



alias cdd="cd $DEV_PATH"
alias cdf="cd $FIRMWARE_PATH"
alias cdfo="cd $FIRMWARE_PATH-other-branch"
alias cdfsm="cdf && cd ODS/FSM/Cycles"
alias cdsch="cdf && cd Scheduling"
alias cdsimul="cdf && cd Combo/Simul/Files"
alias cds="cd $SCRIPTS_PATH"
alias cdt="cd $TOOLS_PATH"
alias cdto="cd $TOOLS_PATH-other-branch"
alias cmd="/mnt/c/WINDOWS/system32/cmd.exe /c"
alias jsd_copy="pushd $FIRMWARE_PATH/Scheduling \
				&& cp -v ./ia.jsd $ROOTDRIVE/m/respons/Tools/Combo-FS-Simul/Files/0/schedule \
				&& cp -v ./ia.jsn $ROOTDRIVE/m/respons/Tools/Combo-FS-Simul/Files/0/schedule \
				; popd \\
				&& pushd $FIRMWARE_PATH/SchedulerUnitTests/Test1 \
				&& cp -v ./IAtestdata.ana $ROOTDRIVE/m/respons/Tools/scripts/Test1/IAtestdata.ana.txt \
				; popd
				"
alias ledappli_clean="pushd $FIRMWARE_PATH/ODS/LEDappli && make clean; popd"
alias ledappli_make="pushd $FIRMWARE_PATH/ODS/LEDappli && make BOARD=STM32P405_HAL MODULE=IA DEBUG=TRUE && copy_bin_to_msi ledappli; echo; read -p \"Appuyez sur entrée... \"; popd"
alias vcp_clean="pushd $FIRMWARE_PATH/ODS/vcp && make clean; popd"
alias vcp_make="pushd $FIRMWARE_PATH/ODS/vcp &&  make BOARD=STM32P405_HAL MODULE=IA && copy_bin_to_msi vcpF4; echo; read -p \"Appuyez sur entrée... \"; popd"
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
	p1=$@
	ROOT_FOLDER=$(get_git_folder)/..
	export ROOT_FOLDER
	
	if [[ "$p1" == "" ]]; then
		echo "First parameter could contains ledappli, incubator, separator, measmeca, hydro1, hydro2, pmt, vcpF4, vcpGB (non HAL), vcpGB_HAL, vcppmt"
		echo "For many target, use '\"' like"
		echo "${FUNCNAME[0]} \"ledappli incubator separator measmeca hydro1 hydro2\""
		return 1
	fi
		
	
	DT_ARM_FIRMWARE="$DEV_PATH/STM32_Toolchain/dt-arm-firmware"
	
	if [[ "$(contains ledappli "$p1")" == "1" ]]; then
		echo -e $GREEN"LEDappli for Red Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/LEDappli/build/bin-spl_IA/LEDappli_IA.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/IA.bin"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains incubator "$p1")" == "1" ]]; then
		echo -e $GREEN"INCUBATOR.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_IA/INCUBATOR.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/INCUB.bin"; echo $CMD; $CMD
		
	fi
	if [[ "$(contains separator "$p1")" == "1" ]]; then
		echo -e $GREEN"SEPAR.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_IA/SEPARATOR.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/SEPAR.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains measmeca "$p1")" == "1" ]]; then
		echo -e $GREEN"MEASMECA.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_IA/MEASMECA.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/MEASM.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro1 "$p1")" == "1" ]]; then
		echo -e $GREEN"HYDRO1.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_IA/HYDRO1.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/HYDRO1.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro2 "$p1")" == "1" ]]; then
		echo -e $GREEN"HYDRO2.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/StepMotor/build/bin-spl_IA/HYDRO2.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/HYDRO2.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains pmt "$p1")" == "1" ]]; then
		echo -e $GREEN"PMT.bin for Generic Board"$ATTR_RESET
		CMD="cp  $DT_ARM_FIRMWARE/ODS/PMTboardAppli/bin-spl_IA/PMTboardAppli.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/PMT.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcpF4 "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for Red Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binred-hal-f4/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains vcpGB "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for Generic Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/bin-spl_IA/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcpGB_HAL "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp-HAL for Generic Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/bingen-hal-f4/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPGENERIC-HAL.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcppmt "$p1")" == "1" ]]; then
		echo -e $GREEN"vcp for PMT Board"$ATTR_RESET
		CMD="cp $DT_ARM_FIRMWARE/ODS/vcp/build/binpmt/vcp.bin $ROOTDRIVE/m/respons/Tools/Combo_Firmware_perso/VCPPMT.BIN"; echo $CMD; $CMD
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
		echo $logPath$lastDir
	else
		echo "Not in firmware folder"
		return $ERR
	fi
}

npp() {
## exec /mnt/e/Tools/Notepad++/notepad++.exe "$@"
    CMD="/mnt/e/Tools/Notepad++/notepad++.exe \"$(conv_path_for_win $@)\""
    echo $CMD
	eval "$CMD" 2>/dev/null&
}

get_version()
{
	version=$(cat $FIRMWARE_PATH/ODS/LEDappli/version.c | grep FIRMWARE_VERSION)
	version=${version#*\"}
	version=${version%\"*}
	echo $version
}

ganttproject()
{
	path="$1"
	CMD="/mnt/e/Tools/GanttProject/ganttproject.exe $(wslpath -w $path)"
	echo $CMD
	$CMD&
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


####################################################################################################
# Parse a Scheduler Log file, and extract Scheduler frame file
sch_extract_frames()
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
	final_output_frames="$destPath/$logfile_without_ext"_SCH_Frames.txt
	
	# Keep only frames
	echo -e $GREEN"Extracting lines with frame" $ATTR_RESET
	CMD="cat $logfile | egrep ']\ ->\ {' > $output_frames_1"
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
	
	# Replace "end"}};50; by "end"}};;
	rm -vf $final_output_frames
	search='\"end\"}};50;'
	replace='\"end\"}};;'
	echo -e $GREEN"Replace $search by $replace" $ATTR_RESET
	CMD="cat $output_frames_5 |  sed \"s,$search,$replace,g\" "
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
	search="\\\"end\\\"}};;"
	replace="\\\"end\\\"}};$timeout_value;"
	echo -e $GREEN"Replace $search by $replace" $ATTR_RESET
	CMD="cat $logfile |  sed \"s,$search,$replace,g\"  | tee $tmp_file"
	echo $CMD; eval "$CMD"
	rm -f $logfile
	mv -f $tmp_file $logfile
	echo -e $GREEN"$logfile done!" $ATTR_RESET
	
	echo -e $GREEN"Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
}

####################################################################################################
# Parse frame file, and generate a new file on each "fct":{"name":"IAsched", "type" : "end"}} found
sch_split_frame_file()
{
	if [[ "$#" -le "1" ]]; then
		echo "Parse frame file, and generate a new file on each (\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}};;) found"
		echo "#1 is the frame file"
		echo "  Each new file generated is named '#1__Cycle_\index_file\.txt'"
		return
	fi
	logfile=$1
	logfile_without_ext=${logfile%.*}

	# Replace "end"}};; by "end"}};$timeout_value;
	search="\"fct\":{\"name\":\"IAsched\", \"type\" : \"end\"}}"
	index_file=1
	cat $logfile | while read line
	do
		final_output_frames="$logfile_without_ext""_Cycle_"$index_file".txt"
		echo $line >> $final_output_frames
		END=$(echo $line | grep "$search")
		if [[ "$END" != "" ]]; then
			index_file=$(($index_file + 1))
			echo "final_output_frames= "$final_output_frames
		fi
	done
	echo -e $GREEN"Done! (from $logfile)"
	echo $BLUE$final_output_frames $ATTR_RESET
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

wedit() {
	local path=$(which "$1" 2>/dev/null)
	CMD="npp \"$path\""; echo $CMD; eval "$CMD"
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
 
echo Out of BASHRC_DIASYS
