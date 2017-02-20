#!/bin/bash
imgFolder="$HOME/MOUNT_IMG"
isoFolder="$HOME/MOUNT_ISO"
RM=$(which rm)
if [ -e $imgFolder ]; then
	$RM -r $imgFolder
fi
if [ -e $isoFolder ]; then
	$RM -r $isoFolder
fi
imgFile=$1
fullfilename=$(basename $imgFile)
filename=${fullfilename%.*}

FONT_CYAN="\e[96m"
FONT_WHITE="\e[97m"
ATTR_RESET="\e[0m"

## List device loop partition
## sudo parted -l | grep Disk | grep loop

EXE() {
	local cmd="$@ | tee  >(cat - >&5)"
	echo -e "[ $FONT_CYAN$cmd$ATTR_RESET ]" >/dev/stderr
	local output=$(eval $@)
	local err=$?
	if [ "$output" != "" ]; then
		echo $output
	fi
	if [ "$err" != "0" ]; then
		exit $err
	fi
	return $err
}

my_mount() {
	EXE mkdir "$imgFolder"
	EXE mkdir "$isoFolder"

	loopDev=$(EXE sudo losetup -f)
	echo "First loop device is $loopDev"
	echo "Attach loop device $loopDev on image $imgFile"
	EXE sudo losetup $loopDev $imgFile
	echo "Create device maps from partition tables ($loopDev)"
	loopMap=$(EXE sudo kpartx -av $loopDev)
	loop=$(basename $loopDev)
	loopPart=${loopMap##* $loop}
	loopPart=${loopPart%% *}

	echo "Mounting /dev/mapper/$loop$loopPart on $imgFolder..."
	echo "loop=$loop"
	echo "loopPart=$loopPart"
	EXE sudo mount "/dev/mapper/$loop$loopPart $imgFolder -t auto"
	echo "Mounting $isoFile on $isoFolder..."
	EXE sudo mount $isoFile $isoFolder
}

my_umount() {
	EXE sudo parted $loopDev set 1 boot on
	EXE sudo parted $loopDev print
	echo "Unmounting $imgFolder $isoFolder..."
	EXE sudo umount $imgFolder $isoFolder
	echo "Echo setting options for $loopDev..."
	EXE sudo kpartx -d $loopDev
	EXE sudo losetup -d $loopDev
#	EXE $RM -r $imgFolder
#	EXE $RM -r $isoFolder
}

main() {
	SVG_IFS=$IFS
	IFS=""
	exec 5>&1

	imgFile_FULLFILENAME=$fullfilename
	isoFile="$filename.iso"
	fstat=$(eval "stat -L -c%s $imgFile")
	echo "fstat=$fstat"
	size=$((1 + $fstat / 1024 / 1024)) ## convert in MB
	echo "ISO size will be= "$size"MB"
	echo "Fullfil (with zero) the created image file"
	EXE dd if=/dev/zero of=$isoFile count=$((1024 * 1024)) bs=$size
	echo "Formatting the created image file as FAT32"
	EXE mkfs.vfat -F 32 $isoFile

	echo "MOUNTING"
	my_mount

	echo "Copy content of $imgFolder in $isoFolder..."
	EXE sudo cp -avR "$imgFolder/*" "$isoFolder/"
	EXE sync

	my_umount
	IFS=$SVG_IFS
}

main
