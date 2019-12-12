echo
echo In BASHRC_LINUXBASH
export BASH_STR="Ubuntu bash on Windows"
export HOME_IN_WINDOWS="C:\Users\fpaut\AppData\Local\Packages\CanonicalGroupLimited.UbuntuonWindows_79rhkp1fndgsc\LocalState\rootfs\home\fpaut"
export ROOTDRIVE="/mnt"
export HOMEW="$ROOTDRIVE/c/Users/fpaut"

alias rm='trash -v'
alias trash-restore='restore-trash'

conv_path_for_win()
{
    echo $@
}
export -f conv_path_for_win

conv_path_for_bash()
{
	echo $@
}
export -f conv_path_for_bash

function ctrl_c() {
    echo
}

echo Out of BASHRC_LINUXBASH
