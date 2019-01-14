if ! [ -e bin/RNDIS-F7.elf ]; then
    echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
    exit
fi
OPENOCD="/cygdrive/c/Users/fpaut/bin/Openocd/OpenOCD-20180728/bin/openocd.exe"
CMD="$OPENOCD -f C:\Users\fpaut\dev\STM32_Toolchain\generic-board-stm32f7x.cfg" 
echo $CMD
$CMD
