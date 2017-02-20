SSID=$1
PWD=$2

if [ -z $SSID ]; then
	echo "First Parameter could not be null (SSID)"
	exit 1
fi

if [ -z $PWD ]; then
	echo "Second Parameter could not be null (password)"
	exit 1
fi

function sendkeys()
{
	for k in $@
	do
		echo -n " $k"
		adb shell input keyevent $k
	done
}

adb shell am start com.android.settings
sleep 1

sendkeys DPAD_DOWN ENTER DPAD_DOWN DPAD_UP DPAD_RIGHT DPAD_RIGHT
adb shell input text $SSID

sendkeys DPAD_DOWN ENTER DPAD_DOWN DPAD_DOWN ENTER DPAD_DOWN ENTER DPAD_UP
adb shell input text $PWD

sendkeys DPAD_DOWN DPAD_DOWN DPAD_DOWN ENTER


##  /data/local/Inst/bin/valgrind --trace-children=yes --leak-check=full --keep-stacktraces=alloc-and-free am start zausan.zdevicetest
