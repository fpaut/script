set OPENOCD=D:\\Users\\fpaut\\bin\\Openocd\\OpenOCD-20180728\\bin\\openocd.exe
set CFG_LINK=D:\\Users\\fpaut\\bin\\Openocd\\OpenOCD-20180728\\share\\openocd\\scripts\\interface\\stlink.cfg
set CFG_BOARD=D:\\Users\\fpaut\\bin\\Openocd\\OpenOCD-20180728\\share\\openocd\\scripts\\target\\stm32f4x.cfg

@echo CFG_LINK   = %CFG_LINK%
@echo CFG_BOARD  = %CFG_BOARD%
REM @echo VCP_BIN    = %VCP_BIN%
@echo APPLI_BIN  = %APPLI_BIN%
@echo " "
@echo " "
set CMD="%OPENOCD% -f %CFG_LINK% -f "%CFG_BOARD%"  -c "init; reset run; shutdown"
@echo %CMD%
@echo " "
@echo " "

REM If you want to keep the console open, change /C by /K
cmd /C %CMD%

pause