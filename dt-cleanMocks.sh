#!/bin/bash
RM=$(which trash)
exe () 
{
 CMD="$@"
 echo "$CMD"
 eval "$CMD"
}

exe "cd /mnt/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/Tests"
find . -iname mocks | while read folder
do 
	exe "$RM $folder"
done
