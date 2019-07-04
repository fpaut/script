echo
echo In BASHRC_DIASYS

alias cdl="cd $ROOTDRIVE/m/ComboMaster/emulated-disk/Files/0/logs/$(date +%Y%m%d)"
alias cdd="cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain"
alias cdf="cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware"
alias cdfsm="cdf && cd ODS/FSM/Cycles"
##alias cmlog='set -- $(ls -t $(date +%H)*) && file=$1 && file=${file%.*} && rm -f *_filtered.LOG &&  ecat $file.LOG "MEAS_CYCLE|\<MISC\>" "Incubator|Magnet|Separator|Probe|Diluter| ms " > "$file"_filtered.LOG && npp "$file"_filtered.LOG'
alias cds="cd $ROOTDRIVE/d/Users/fpaut/dev/scripts"
alias cdt="cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-fwtools"

deg_to_step()
{
	deg=$1
	echo $(( $(($((600 * $deg)) / 360)) )) steps
	echo $(( $(($((600 * $deg)) / 360)) * 4)) 1/4 steps
}

step_to_deg()
{
	step=$1
	echo $(( $(($step * 360)) / 600 ))° if steps is 1/1 steps
	echo $(($(($step * 360)) / $((600 * 4)) ))° if steps is 1/4 steps
}


copy_bin_to_medios-hp()
{
	cd $ROOTDRIVE/d/Users/fpaut/dev/STM32_Toolchain/dt-arm-firmware
	CMD="cp ODS/LEDappli/bin/LEDappli.bin /cygdrive/m/dev/binFirmware/LEDAppli/"; echo $CMD; $CMD
	CMD="cp ODS/vcp/bin405/vcp.bin /cygdrive/m/dev/binFirmware/LEDAppli/"; echo $CMD; $CMD
	cd -
}

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

step_to_deg()
{
	step=$1
	echo $(( $(($step * 360)) / 600 ))° if steps is 1/1 steps
	echo $(($(($step * 360)) / $((600 * 4)) ))° if steps is 1/4 steps
}




echo Out of BASHRC_DIASYS
