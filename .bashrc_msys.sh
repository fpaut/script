echo BASHRC_MSYS
export BASH_STR="MSYS on Windows"
export HOME_IN_WINDOWS="D:\Users\fpaut"
export ROOTDRIVE=""
export HOMEW="$ROOTDRIVE/d/Users/fpaut"
export HOME=$HOMEW

conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath -w $@)
	fi
}
export -f conv_path_for_win

conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath $@)
	fi
}
export -f conv_path_for_bash
