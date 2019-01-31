# if ! [ -e bin/RNDIS-F7.bin ]; then
#     echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
#     exit
# fi
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
RNDIS_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/RNDIS/bin/rndis.bin")))
RNDIS_APPLI=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/RNDIS/bin/rndis_appli.bin")))
APPLI_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/c/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/LEDappli/bin/LEDappli.bin")))

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo RNDIS_BIN	= $RNDIS_BIN
echo RNDIS_APPLI= $RNDIS_APPLI
echo APPLI_BIN	= $APPLI_BIN
echo; echo
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt \" -c \"flash write_image erase  $RNDIS_BIN 0x08000000\" -c \"flash write_image erase  $RNDIS_APPLI  0x08010000\" -c \"flash write_image erase $APPLI_BIN 0x08020000\" -c \"reset run; shutdown\""
echo $CMD
eval $CMD
