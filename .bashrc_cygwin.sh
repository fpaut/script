echo
echo In BASHRC_CYGWIN
export BASH_STR="CYGWIN bash on Windows"
export HOME_IN_WINDOWS="C:\\cygwin64\\home\\fpaut"
export ROOTDRIVE="/cygdrive"
export HOMEW="$ROOTDRIVE/d/Users/fpaut"
export HOME=$HOMEW

alias sudo="cygstart --action=runas '$@'"

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

echo Out of BASHRC_CYGWIN
