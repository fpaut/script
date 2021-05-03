#/bin/bash
device=$1
if [[ "$device" == "" ]]; then
    echo "First parameter is the device (eg.:/dev/mmcblk0p1)"
    exit 1
fi
sudo dosfsck -t -a -w -v $device
