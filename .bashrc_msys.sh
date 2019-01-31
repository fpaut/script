echo BASHRC_MSYS
export BASH_STR="MSYS on Windows"
export HOME_IN_WINDOWS="C:\Users\fpaut"
export HOMEW="C:\Users\fpaut"
export ROOTDRIVE=""
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
