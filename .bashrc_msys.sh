echo
echo -e $YELLOW"In BASHRC_MSYS"$ATTR_RESET

export BASH_STR="MSYS on Windows"
export HOME_IN_WINDOWS="D:\Users\fpaut"
export ROOTDRIVE="/."
export HOMEW="$ROOTDRIVE/c/Users/fpaut"
SCRIPTS_PATH="$ROOTDRIVE/e/Tools/bin/scripts"
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
echo -e $YELLOW"Out of BASHRC_ALIASES"$ATTR_RESET
