# if ! [ -e bin/RNDIS-F7.bin ]; then
#     echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
#     exit
# fi
appli=$1
if [[ "$appli" == "" ]]; then
	echo "First parameter is the appli name 'DEV.bin' 'SEPARATOR.bin' etc"
	exit 1
fi

conv_path_for_win()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath -w "$@")
	fi
}

conv_path_for_bash()
{
	if [[ "$@" != "" ]]; then
		echo $(wslpath "$@")
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
VCP_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/vcp/bin/vcp.bin")))
APPLI_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/StepMotor/bin/$appli")))

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo VCP_BIN	= $VCP_BIN
echo APPLI_BIN	= $APPLI_BIN
echo; echo
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" -c \"flash write_image erase  $VCP_BIN 0x08000000\" -c \"flash write_image erase $APPLI_BIN 0x08020000\" -c \"reset run; shutdown\""
echo $CMD
eval $CMD
