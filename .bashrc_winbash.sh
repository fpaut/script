echo BASHRC_WINBASH
export BASH_STR="Ubuntu bash on Windows"
export HOME_IN_WINDOWS="C:\Users\fpaut\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\fpaut"
export HOMEW="C:\Users\fpaut"
export ROOTDRIVE="/mnt"
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

meld() {
	CMD="$(which meld) $@"
	echo $CMD
	$CMD
}


