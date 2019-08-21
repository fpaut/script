echo
echo In BASHRC_CYGWIN
export BASH_STR="CYGWIN bash on Windows"
export HOME_IN_WINDOWS="C:\\cygwin64\\home\\fpaut"
export ROOTDRIVE="/cygdrive"
export HOMEW="$ROOTDRIVE/d/Users/fpaut"
export HOME=$HOMEW

alias sudo="cygstart --action=runas "
alias wps="ps -W"
alias wgps="ps -W | grep "
alias wkill="taskkill /pid "

conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(cygpath -w $@)
	fi
}
export -f conv_path_for_win

conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $(cygpath $@)
	fi
}
export -f conv_path_for_bash

killall()
{
	process=$1
	for cmd in /proc/*/
	do
		if [[ -e "$cmd"/cmdline ]]; then 
			present=$(cat "$cmd"cmdline 2>/dev/null| grep $process)
			if [[ "$present" != "" ]]; then
				PID=${cmd%/*}
				PID=${PID##*/}
				# if PID , not our PID and not parent PID
				if [[ "$PID" != "" && "$PID" != "$$" && "$PID" != "$PPID" ]]; then
					kill -9 $PID
				fi
			fi
		fi 
	done
	
}

echo Out of BASHRC_CYGWIN
