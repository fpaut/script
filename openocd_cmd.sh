#!/bin/bash
openocd_cmd="$@"
conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath -w "$@")
	fi
}
double_backslash()
{
	str=$1
	echo $(echo $str |  sed 's,\\,/,g')
}

OPENOCD="$ROOTDRIVE/c/Users/fpaut/bin/Openocd/OpenOCD-20180728/bin/openocd.exe"
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/interface/stlink.cfg"))
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/target/stm32f4x.cfg"))

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD

echo; echo
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"$openocd_cmd\" -c \"reset run; shutdown\""
echo $CMD
eval $CMD
