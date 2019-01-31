if ! [ -e bin/RNDIS-F7.bin ]; then
    echo "Bad folder! ('bin/RNDIS-F7.bin' not found)"
    exit
fi
OPENOCD="/cygdrive/c/Users/fpaut/bin/Openocd/OpenOCD-20180728/bin/openocd.exe"
CMD="$OPENOCD -f c:\\users\\fpaut\\bin\\openocd\\openocd-20180728\\share\\openocd\\scripts\\interface\\stlink.cfg -f c:\\users\\fpaut\\bin\\openocd\\openocd-20180728\\bin\\..\\share\\openocd\\scripts\\board\\stm32f7discovery.cfg -c \"init; reset halt\" -c \"flash write_image erase  bin/RNDIS-F7.bin 0x08000000\" -c \"flash write_image erase bin/RNDIS-F7ext.bin 0x08010000\" -c \"flash write_image erase C:/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/ODS/LEDappli/bin7/LEDappli.bin 0x08040000\" -c \"reset run; shutdown\""
echo $CMD
$CMD
