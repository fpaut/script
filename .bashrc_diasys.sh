echo
echo In BASHRC_DIASYS

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
	cdf
	CMD="cp ODS/LEDappli/bin/LEDappli.bin /cygdrive/m/dev/binFirmware/LEDAppli/"; echo $CMD; $CMD
	CMD="cp ODS/vcp/bin405/vcp.bin /cygdrive/m/dev/binFirmware/LEDAppli/"; echo $CMD; $CMD
	cd -
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
