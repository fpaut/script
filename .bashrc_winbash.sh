echo
echo In BASHRC_WINBASH
export BASH_STR="Ubuntu bash on Windows"
export HOME_IN_WINDOWS="C:\Users\fpaut\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\fpaut"
export ROOTDRIVE="/mnt"
export HOMEW="$ROOTDRIVE/c/Users/fpaut"
export HOME=$HOMEW

alias rm='trash -v'
alias trash-restore='restore-trash'
export WSLPATH=$(which wslpath)

conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $($WSLPATH -w $@)
	fi
}
export -f conv_path_for_win

conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $($WSLPATH $@)
	fi
}
export -f conv_path_for_bash

wslpath()
{
	case "$1" in
		"" | "help" | "-help" | "--help")
			echo "wslpath usage:"
			echo "    -a    force result to absolute path format"
			echo "    -u    translate from a Windows path to a WSL path (default)"
			echo "    -w    translate from a WSL path to a Windows path"
			echo "    -m    translate from a WSL path to a Windows path, with ‘/’ instead of ‘\\’"
		;;
		*)
			$WSLPATH "$@"
		;;
	esac
}
export -f wslpath

function ctrl_c() {
	echo "SIGINT trapped!" 
}

echo "Remap CTRL+C on CTRL+X"
stty intr \^x

# trap ctrl-c and call ctrl_c()
trap ctrl_c SIGINT

echo Out of BASHRC_WINBASH
