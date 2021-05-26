#!/bin/bash
ISS_file="$1"
if [[ "$ISS_file" == "" ]]; then
	echo "#1 is '.iss' file script name for installer generation"
	echo "eg.: iscc ./Combo_Jenkins_ComboMaster_Only.iss"
	exit 1
fi
# Refresh ComboMaster executable
touch  /mnt/e/dev/STM32_Toolchain/dt-arm-firmware/ODS/Simulator/ComboMaster/ComboMasterDlg.cpp
msbuild E:\\dev\\STM32_Toolchain\\dt-arm-firmware\\ODS\\Simulator\\ComboMaster.sln


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
