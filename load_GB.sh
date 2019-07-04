# if ! [ -e bin/RNDIS-F7.bin ]; then
#     echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
#     exit
# fi
appli=$1
vcp=$2
if [[ "$appli" == "" ]]; then
	echo "First parameter is the appli name 'DEV.bin' 'SEPARATOR.bin' etc"
	echo "Second parameter is optional and is the vcp 'vcp.bin' etc"
	exit 1
fi

OPENOCD="$ROOTDRIVE/d/Users/fpaut/bin/Openocd/OpenOCD-20180728/bin/openocd.exe"
## OLIMEX ## 
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/interface/ftdi/olimex-arm-usb-tiny-h.cfg"))
## OLIMEX: JTAG/SWD ## 
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/interface/ftdi/olimex-arm-jtag-swd.cfg"))

## STLINK / NUCLEO ## 
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/interface/stlink.cfg"))
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/bin/Openocd/OpenOCD-20180728//share/openocd/scripts/target/stm32f4x.cfg"))


VCP_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/vcp/bin405/$vcp")))
APPLI_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/StepMotor/bin/$appli")))

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo VCP_BIN	= $VCP_BIN
echo APPLI_BIN	= $APPLI_BIN
echo; echo
if [[ "$vcp" == "" ]]; then
	CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" -c \"flash write_image erase $APPLI_BIN 0x08020000\" -c \"reset run; shutdown\""
else
	CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" -c \"flash write_image erase  $VCP_BIN 0x08000000\" -c \"flash write_image erase $APPLI_BIN 0x08020000\" -c \"reset run; shutdown\""
fi
echo $CMD
eval $CMD
