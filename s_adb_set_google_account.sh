LOGIN=$1
PWD=$2

if [ "$LOGIN" = "" ]; then
	echo "First parameter (login) is empty. Exit..."
	exit 1;
fi

if [ "$PWD" = "" ]; then
	echo "Second parameter (password) is empty. Exit..."
	exit 1;
fi

function sendkeys()
{
	for k in $@
	do
		echo $k
		adb shell input keyevent $k
	done
}

function wait_boot_completed()
{
  booted=`adb shell 'getprop sys.boot_completed' | cut -b 1`
  if  [ ! "$booted" = "1" ]; then
	echo "---- waiting for device reboot..."
  else
	while [ ! "$booted" = "1" ]
	do
		echo -n "."
		sleep 3
		booted=`adb shell 'getprop sys.boot_completed' 2> /dev/null | cut -b 1`
	done
  fi
}

wait_boot_completed

adb shell am kill com.android.settings
sendkeys HOME

sleep 1
adb shell am start com.android.settings

echo 'SELECT "add account"'
sendkeys DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN ENTER
sendkeys DPAD_DOWN ENTER ENTER

echo 'ENTER login'
adb shell input text "$LOGIN"
echo 'ENTER password'
sendkeys DPAD_DOWN
adb shell input text "$PWD"
sendkeys DPAD_DOWN DPAD_RIGHT ENTER
echo 'Avoid popup'
sendkeys DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN DPAD_DOWN  DPAD_DOWN  DPAD_DOWN ENTER



