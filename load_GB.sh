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

OPENOCD="$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/bin/openocd.exe"
## OLIMEX ## 
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/interface/ftdi/olimex-arm-usb-tiny-h.cfg"))
## OLIMEX: JTAG/SWD ## 
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/interface/ftdi/olimex-arm-jtag-swd.cfg"))

## STLINK / NUCLEO ## 
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/interface/stlink.cfg"))
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/target/stm32f4x.cfg"))


if [[ "$1" == "vcpgen" ||  "$2" == "vcpgen" ]]; then
	VCP_BIN=$(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/vcp/build/bin/vcp.bin"))
	VCP_BIN=$(double_backslash $VCP_BIN)
else
	VCP_BIN=""
fi
if [[ "$1" == "vcpgen-hal" ||  "$2" == "vcpgen-hal" ]]; then
	VCP_BIN=$(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/vcp/build/bingen-hal-f4/vcp.bin"))
	VCP_BIN=$(double_backslash $VCP_BIN)
else
	VCP_BIN=""
fi
FLASH_VCP="-c \"flash write_image erase  \"$VCP_BIN\" 0x08000000\""

if [[ "appli" != "" ]]; then
	APPLI_BIN=$(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/StepMotor/build/bin/$appli"))
	APPLI_BIN=$(double_backslash $APPLI_BIN)
else
	APPLI_BIN=""
fi
FLASH_APPLI="-c \"flash write_image erase $APPLI_BIN 0x08020000\""

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo VCP_BIN	= $VCP_BIN
echo APPLI_BIN	= $APPLI_BIN
echo; echo
if [[ "$VCP_BIN" == "" ]]; then
	FLASH_VCP=""
fi
if [[ "$APPLI_BIN" == "" ]]; then
	FLASH_APPLI=""
fi
echo FLASH_VCP="$FLASH_VCP"
echo FLASH_APPLI="$FLASH_APPLI"
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" $FLASH_VCP $FLASH_APPLI -c \"reset run; shutdown\""
echo $CMD
eval $CMD
