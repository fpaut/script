echo BASHRC_MSYS
export BASH_STR="MSYS on Windows"
export HOME_IN_WINDOWS="C:\Users\fpaut"
export ROOTDRIVE=""
export HOMEW="$ROOTDRIVE/c/Users/fpaut"
export HOME=$HOMEW

conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath -w $@)
	fi
}

conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath $@)
	fi
}
