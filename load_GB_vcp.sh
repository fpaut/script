# if ! [ -e bin/RNDIS-F7.bin ]; then
#     echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
#     exit
# fi
OPENOCD="$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/bin/openocd.exe"
CFG_LINK=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/interface/stlink.cfg"))
CFG_BOARD=$(double_backslash $(conv_path_for_win "$ROOTDRIVE/e/Tools/Openocd/OpenOCD-20180728/share/openocd/scripts/target/stm32f4x.cfg"))
VCP_BIN=$(double_backslash $(conv_path_for_win "$(get_git_folder)/../ODS/vcp/build/bingen-hal-f4/vcp.bin"))
VCP_BIN=$(double_backslash $VCP_BIN)

echo CFG_LINK	= $CFG_LINK
echo CFG_BOARD	= $CFG_BOARD
echo VCP_BIN	= $VCP_BIN
echo; echo
CMD="$OPENOCD -f \"$CFG_LINK\" -f $CFG_BOARD -c \"init; reset halt\" -c \"flash write_image erase  $VCP_BIN 0x08000000\" -c \"reset run; shutdown\""
echo $CMD
eval $CMD
