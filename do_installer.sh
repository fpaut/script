#!/bin/bash
ISS_file="$1"
if [[ "$ISS_file" == "" ]]; then
	echo "#1 is '.iss' file script name for installer generation"
	echo "eg.: iscc ./Combo_Jenkins_ComboMaster_Only.iss"
	exit 1
fi
# Refresh ComboMaster executable
echo -n >> /mnt/e/dev/STM32_Toolchain/dt-arm-firmware/ODS/VisualBin/Debug/ComboMaster.exe
if [[ "$?" != "0" ]]; then
	echo -e $RED"ComboMaster.exe is open. Close it before"$ATTR_RESET
	exit 0
fi

touch  /mnt/e/dev/STM32_Toolchain/dt-arm-firmware/ODS/Simulator/ComboMaster/ComboMasterDlg.cpp


echo -e $CYAN"Recompiling ComboMaster.exe to update build time"$ATTR_RESET
msbuild E:\\dev\\STM32_Toolchain\\dt-arm-firmware\\ODS\\Simulator\\ComboMaster.sln | grep --color=always \.cpp | grep -v warning 

echo -e $CYAN"Generate installer..."$ATTR_RESET
output_name=$(cat "$ISS_file" | grep OutputBaseFilename)
output_name=${output_name#*=}
output_name=${output_name%{*}
echo output_name=$output_name

CMD="iscc \"$ISS_file\" | grep \"$output_name\" | grep -v Deleting"
echo "$CMD"
OUTPUT=$(eval $CMD)
OUTPUT=$(wslpath -u $(echo $OUTPUT|dos2unix))
CMD="cp -v \"$OUTPUT\" /mnt/m/respons/Tools/"
echo $CMD
eval "$CMD"
echo -e $CYAN"Done!"$ATTR_RESET
