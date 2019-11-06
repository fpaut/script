echo
echo In BASHRC_DIASYS

FIRMWARE_PATH="$ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware"
TOOLS_PATH="$ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-fwtools"


alias cdl="cd $ROOTDRIVE/m/ComboMaster/emulated-disk/Files/0/logs/$(date +%Y%m%d)"
alias cdd="cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain"
alias cdf="cd $FIRMWARE_PATH"
alias cdfsm="cdf && cd ODS/FSM/Cycles"
##alias cmlog='set -- $(ls -t $(date +%H)*) && file=$1 && file=${file%.*} && rm -f *_filtered.LOG &&  ecat $file.LOG "MEAS_CYCLE|\<MISC\>" "Incubator|Magnet|Separator|Probe|Diluter| ms " > "$file"_filtered.LOG && npp "$file"_filtered.LOG'
alias cds="cd $ROOTDRIVE/d/Users/fpaut/dev/scripts"
alias cdt="cd $TOOLS_PATH"
alias jenkins_CLI="java -jar jenkins-cli.jar -auth pautf:QtxS1204+ -s http://FRSOFTWARE02:8080/"

cmlog()
{
	file=$1
	file=${file%.*}
	if [[ "$file" == "" ]]; then
		set -- $(ls -t $(date +%H)*)
		file=$1
		file=${file%.*}
	fi
	echo FILE=$file
	rm -f *_filtered.LOG
	ecat $file.LOG "MEAS_CYCLE|\<MISC\>" "Incubator|Magnet|Separator|Probe|Diluter| ms " > "$file"_filtered.LOG
	npp "$file"_filtered.LOG
}

deg_to_step()
{
	deg=$1
	echo $(( $(($((600 * $deg)) / 360)) )) steps
	echo $(( $(($((600 * $deg)) / 360)) * 4)) 1/4 steps
}


copy_bin_to_medios_hp()
{
	p1=$1
	
	if [[ "$p1" == "" ]]; then
		echo "First parameter could contains ledappli, vcp, vcpGB, vcppmt, incubator, separator hydro1, hydro2, measmeca, pmt"
		echo "For many target, use '\"' like"
		echo "${FUNCNAME[0]} \"ledappli vcp vcpGB vcppmt incubator separator hydro1 hydro2 measmeca pmt\""
		return 1
	fi
		
	
	cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware
	
	if [[ "$(contains ledappli "$p1")" == "1" ]]; then
		CMD="cp ODS/LEDappli/bin/LEDappli.bin /cygdrive/m/dev/binFirmware/binF4/"; echo $CMD; $CMD
		CMD="cp ODS/LEDappli/bin/LEDappli.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/IA.bin"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains vcp "$p1")" == "1" ]]; then
		CMD="cp ODS/vcp/bin405/vcp.bin /cygdrive/m/dev/binFirmware/binF4/"; echo $CMD; $CMD
	fi
	
	if [[ "$(contains incubator "$p1")" == "1" ]]; then
		CMD="cp  ODS/StepMotor/bin/INCUBATOR.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
		CMD="cp  ODS/StepMotor/bin/INCUBATOR.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/INCUB.bin"; echo $CMD; $CMD
		
	fi
	if [[ "$(contains separator "$p1")" == "1" ]]; then
		CMD="cp  ODS/StepMotor/bin/SEPARATOR.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
		CMD="cp  ODS/StepMotor/bin/SEPARATOR.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/SEPAR.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains measmeca "$p1")" == "1" ]]; then
		CMD="cp  ODS/StepMotor/bin/MEASMECA.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
		CMD="cp  ODS/StepMotor/bin/MEASMECA.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/MEASM.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro1 "$p1")" == "1" ]]; then
		CMD="cp  ODS/StepMotor/bin/HYDRO1.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
		CMD="cp  ODS/StepMotor/bin/HYDRO1.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/HYDRO1.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains hydro2 "$p1")" == "1" ]]; then
		CMD="cp  ODS/StepMotor/bin/HYDRO2.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
		CMD="cp  ODS/StepMotor/bin/HYDRO2.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/HYDRO2.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains pmt "$p1")" == "1" ]]; then
		CMD="cp  ODS/PMTboardAppli/bin/PMTboardAppli.bin /cygdrive/m/dev/binFirmware/binGB/PMT.bin"; echo $CMD; $CMD
		CMD="cp  ODS/PMTboardAppli/bin/PMTboardAppli.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/PMT.bin"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcpGB "$p1")" == "1" ]]; then
		CMD="cp ODS/vcp/bin405/vcp.bin /cygdrive/m/dev/binFirmware/binGB/"; echo $CMD; $CMD
##		CMD="cp ODS/vcp/bin405/vcp.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/"; echo $CMD; $CMD
	fi
	if [[ "$(contains vcppmt "$p1")" == "1" ]]; then
		CMD="cp ODS/vcp/binpmt/vcp.bin /cygdrive/m/dev/binFirmware/binGB/vcppmt.bin"; echo $CMD; $CMD
##		CMD="cp ODS/vcp/binpmt/vcp.bin /cygdrive/m/ComboMaster/emulated-disk/Files/0/firmware/"; echo $CMD; $CMD
	fi
	
	cd -
}

copy_rawIpClient_to_medios_hp()
{
	cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/
	CMD="cp -f dt-fwtools/RuntimeFolderRelease/RawIpClient.exe /cygdrive/m/dev/rawIpClientScripts/"; echo $CMD; $CMD
	cd - 1>/dev/null
}

copy_rawIpClientScript_to_medios_hp()
{
	cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/
	CMD="rm -rf /cygdrive/m/dev/rawIpClientScripts/*"; echo $CMD; $CMD
	CMD="cp -rf ./rawIpClientScripts/* /cygdrive/m/dev/rawIpClientScripts"; echo $CMD; $CMD
	CMD="cp -f dt-fwtools/RuntimeFolderRelease/RawIpClient.exe /cygdrive/m/dev/rawIpClientScripts/"; echo $CMD; $CMD
	CMD="rm -f /cygdrive/m/dev/rawIpClientScripts/Update_RawIpClient.ps1"; echo $CMD; $CMD
	cd - 1>/dev/null
}

copy_web_pages_to_medios_hp()
{
	CMD="cp -vr /cygdrive/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware/Combo/Simul/Files/1/www/* /cygdrive/m/ComboMaster/emulated-disk/Files/1/www/"
	echo $CMD; $CMD
}

get_version()
{
	version=$(cat $FIRMWARE_PATH/ODS/LEDappli/version.c | grep FIRMWARE_VERSION)
	version=${version#*\"}
	version=${version%\"*}
	echo $version
}

step_to_deg()
{
	step=$1
	echo $(( $(($step * 360)) / 600 ))° if steps is 1/1 steps
	echo $(($(($step * 360)) / $((600 * 4)) ))° if steps is 1/4 steps
}


cd $HOME/dev/scripts
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "my scripts\t: $FILEMODE"
cd - 1>/dev/null
cd $HOME/dev/STM32_Toolchain/dt-arm-firmware
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-arm-firmware\t: $FILEMODE"
cd - 1>/dev/null
cd $HOME/dev/STM32_Toolchain/dt-fwtools
git config core.fileMode false
FILEMODE=$(cat .git/config | grep -i filemode)
echo -e "dt-fwtools\t: $FILEMODE"
cd - 1>/dev/null


echo Out of BASHRC_DIASYS
