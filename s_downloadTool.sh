#!/bin/bash
if [ "$#" != "2" ]; then
	echo "2 parameters required"
	echo "#1 is erase mode"
	echo "#2 is file to flash"
	exit 1
fi
erase_mode=$1
shift
flsPath="$@"
CMD="~/bin/DownloadTool/DownloadTool -c1 --erase-mode $erase_mode --library ~/bin/DownloadTool/libDownloadTool.so $flsPath"
echo $CMD
eval $CMD
