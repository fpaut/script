#!/bin/bash
tstType=$1 # 'cts', 'xts', ...
class=$2
method=$3
case $tstType in
	cts)
		tstCmd="./cts-tradefed run cts "
	;;
	xts)
		tstCmd="./xts-tradefed run xts "
	;;
	*)
		echo "Unknow kind of test ($tstType). Exiting"
		exit
	;;
esac

cmd="adb wait-for-device"; echo $cmd; $cmd
cmd="adb logcat -c"; echo $cmd; $cmd
if [ "$method" != "" ]; then
	cts_output="./log$tstType-tradefed-$class#$method.txt"
	cmd="$tstCmd --class $class  --method $method <<< exit"
	echo -e "Command was : $cmd\n\n" > $cts_output
	cmd="$cmd 2>&1 >> $cts_output"
	echo $cmd; eval $cmd
	logcat_output="./logcat_$method.txt"
else
	cts_output="./log$tstType-tradefed-$class.txt"
	cmd="$tstCmd --package $class  <<< exit"
	echo -e "Command was : $cmd\n\n" > $cts_output
	cmd="$cmd 2>&1 >> $cts_output"
	echo $cmd; eval $cmd
	logcat_output="./logcat_$class.txt"
fi
cat $cts_output | grep result
cmd="adb logcat -d -b all *:V > $logcat_output"; echo $cmd; eval  $cmd
echo "cts-tradefed output is $cts_output"
echo "Logcat output is $logcat_output"
cd -

