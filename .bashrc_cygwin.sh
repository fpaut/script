echo BASHRC_CYGWIN
export BASH_STR="CYGWIN bash on Windows"
export HOME_IN_WINDOWS="C:\\cygwin64\\home\\fpaut"
export HOMEW="/cygdrive/c/Users/fpaut"
export ROOTDRIVE="/cygdrive"
conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(cygpath -w $@)
	fi
}


conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $(cygpath $@)
	fi
}
