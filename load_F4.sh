# if ! [ -e bin/RNDIS-F7.bin ]; then
#     echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
#     exit
# fi
if [[ "$1" == "" ]]; then
	echo "Parameter(s) requested!"
	echo "Possible values are : vcp / vcp-hal / ledappli / rndis / rndisappli"
	exit 1
fi


OPENOCD="$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/bin/openocd.exe"
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/interface/stlink.cfg"))
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/target/stm32f4x.cfg"))
VCP_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/vcp/bin405/vcp.bin")))
VCP_HAL_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/vcp/build/binred-hal-f4/vcp.bin")))
APPLI_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/LEDappli/build/bin/LEDappli.bin")))
RNDIS_BIN=$(double_backslash $(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/RNDIS/bin/rndis.bin")))
RNDIS_APPLI=$(double_backslash $(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/RNDIS/bin/rndis_appli.bin")))

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo VCP_BIN	= $VCP_BIN
echo APPLI_BIN	= $APPLI_BIN
echo; echo
if [[ "$1" == "vcp" ||  "$2" == "vcp" ]]; then
	FLASH_VCP="-c \"flash write_image erase  $VCP_BIN 0x08000000\""
fi
if [[ "$1" == "vcp-hal" ||  "$2" == "vcp-hal" ]]; then
	FLASH_VCP="-c \"flash write_image erase  $VCP_HAL_BIN 0x08000000\""
fi
if [[ "$1" == "ledappli" ||  "$2" == "ledappli" ]]; then
	FLASH_LEDAPPLI="-c \"flash write_image erase $APPLI_BIN 0x08020000\""
fi
if [[ "$1" == "rndis" ||  "$2" == "rndis" ]]; then
	FLASH_RNDIS="-c \"flash write_image erase  $RNDIS_BIN 0x08000000\""
fi
if [[ "$1" == "rndisappli" ||  "$2" == "rndisappli" ]]; then
	FLASH_RNDISAPPLI="-c \"flash write_image erase  $RNDIS_APPLI  0x08010000\""
fi
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" $FLASH_RNDIS $FLASH_VCP $FLASH_RNDISAPPLI $FLASH_LEDAPPLI -c \"reset run; shutdown\""
echo "$CMD"
eval "$CMD"
ERR=$?
if [[ "$ERR" != "0" ]]; then
	echo ERREUR while flashing!
	exit $ERR
fi
