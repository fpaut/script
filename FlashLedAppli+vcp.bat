set OPENOCD=C:\\Users\\Combo\\Desktop\\DT-Combo-Tools\\sharedFolder\\dev\\OpenOCD-20190426-0.10.0\\bin\\openocd.exe
set CFG_LINK=C:\\Users\\Combo\\Desktop\\DT-Combo-Tools\\sharedFolder\\dev\\OpenOCD-20190426-0.10.0\\share\\openocd\\scripts\\interface\\stlink.cfg
set CFG_BOARD=C:\\Users\\Combo\\Desktop\\DT-Combo-Tools\\sharedFolder\\dev\\OpenOCD-20190426-0.10.0\\share\\openocd\\scripts\\target\\stm32f4x.cfg
set VCP_BIN=C:\\Users\\Combo\\Desktop\\DT-Combo-Tools\\sharedFolder\\dev\\binFirmware\\LEDAppli\\vcp.bin
set APPLI_BIN=C:\\Users\\Combo\\Desktop\\DT-Combo-Tools\\sharedFolder\\dev\\binFirmware\\LEDAppli\\LEDappli.bin

@echo CFG_LINK   = %CFG_LINK%
@echo CFG_BOARD  = %CFG_BOARD%
@echo VCP_BIN    = %VCP_BIN%
@echo APPLI_BIN  = %APPLI_BIN%
@echo " "
@echo " "
set CMD="%OPENOCD% -f %CFG_LINK% -f "%CFG_BOARD%" -c "init; reset halt" -c "flash write_image erase  %VCP_BIN% 0x08000000" -c "flash write_image erase %APPLI_BIN% 0x08020000" -c "reset run; shutdown"
@echo %CMD%
@echo " "
@echo " "

## If you want to keep the console open, change /C by /K
cmd /C %CMD%

pause
