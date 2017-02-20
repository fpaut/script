#!/bin/sh
shopt -s expand_aliases
alias errorHandler_on_error='ERR=$?; if [[ $ERR != 0 ]]; then errorHandler $ERR; fi'
REPAIROS_IMG=$1
DEST_FS_PATH=$2
PWD=$(pwd)
MOUNT_IMG_PATH="$HOME/MOUNT_IMG"
MOUNT_IMGSFS_PATH="$HOME/MOUNT_IMGSFS"
MOUNT_ROOTFS_PATH="$HOME/MOUNT_ROOTFS"
logErr="./logErr.txt"
success=0
error=1

FONT_CYAN="\e[96m"
FONT_WHITE="\e[97m"
ATTR_RESET="\e[0m"

def_font_attributes() {
	fontCyan="\e[96m"
	fontRed="\e[91m"
	fontGreen="\e[92m"
	fontBlue="\e[34m"
	fontYellow="\e[93m"
	fontWhite="\e[97m"
	attrReset="\e[0m"
}

# because 'rm' command a sudoer could be extremly dangerous, this function is an overloard to try to avoid dangerous case...
myRm() {
	CONTINUE=true
	PARAMS=$@
	YES_FOR_ALL=false
	ERR=$success
	set -- $@
	while [ "$#" != "0" ] && [ "$YES_FOR_ALL" = "false" ]
	do
		PARAMETER="\\"$1
		FIRST_CHAR=${PARAMETER:1:1}
		if [ "$FIRST_CHAR" = "/" ]; then
            if [ -d "$1" ]; then
                read -e -i "N" -p "Suspicious parameter ${PARAMETER:1}, continue? ('y'es/'a'll yes/'N'o/'q'uit): "
                case $REPLY in
					n | N)
						CONTINUE=false
						ERR=$error
						break
					;;
					a | A)
						CONTINUE=true
						YES_FOR_ALL=true
						break
					;;
					q | Q)
						exit
					;;
				esac
            fi
		fi
		shift
	done
	if [ "$CONTINUE" = "true" ]; then
		EXE "rm $PARAMS"
	fi
	return $ERR
}

EXE() {
	CMD=$@
	echo -e "[ $FONT_CYAN$CMD$ATTR_RESET ]" >/dev/stderr
	OUT=$(eval $@ 2>&1)
	ERR=$?
	if [ "$OUT" != "" ]; then
		echo $OUT
	fi
	if [ "$ERR" != "0" ]; then
		echo $OUT >> $logErr
	fi
	return $ERR
}

recreate_dir() {
	DIR=$1
	if [ -e $DIR ]; then
		myRm -rf "$DIR"; errorHandler_on_error
	fi
	EXE mkdir "$DIR"; errorHandler_on_error
}

my_mount() {
	recreate_dir "$MOUNT_IMG_PATH"
	recreate_dir "$DEST_FS_PATH"
	recreate_dir "$MOUNT_IMGSFS_PATH"
	recreate_dir "$MOUNT_ROOTFS_PATH"

	LOOP_DEV=$(EXE losetup -f)
	EXE losetup $LOOP_DEV $REPAIROS_IMG; errorHandler_on_error
	LOOP_MAP=$(EXE kpartx -av $LOOP_DEV); errorHandler_on_error
	LOOP=$(basename $LOOP_DEV)
	LOOP_PART=${LOOP_MAP##* $LOOP}
	LOOP_PART=${LOOP_PART%% *}

	EXE "mount /dev/mapper/$LOOP$LOOP_PART $MOUNT_IMG_PATH"; errorHandler_on_error
	IFS=$' \n'
	fileList=($(EXE "ls -S $MOUNT_IMG_PATH") )
	rootFs=${fileList[0]}
	echo "TODO: rootFs=$rootFs"
	EXE "mount $MOUNT_IMG_PATH/$rootFs $MOUNT_IMGSFS_PATH"; errorHandler_on_error
	EXE "cp $MOUNT_IMG_PATH/MANIFEST.* $DEST_FS_PATH"; errorHandler_on_error
	EXE "mount $MOUNT_IMGSFS_PATH/rootfs.img $MOUNT_ROOTFS_PATH"; errorHandler_on_error
	EXE "mkdir $DEST_FS_PATH/sys"; errorHandler_on_error
	EXE "cp -R $MOUNT_ROOTFS_PATH/* $DEST_FS_PATH/sys"; errorHandler_on_error
	cleanup
}

my_umount() {
	FOLDER=$1
	local ERR
	if [ -e "$FOLDER" ]; then
		EXE umount "$FOLDER 2>/dev/null"
		ERR=$?
	fi
	return $ERR
}

cleanup_loopDevice() {
	IFS=$'\n'
	loopList=($(EXE "mount | grep loop"))
	nbLoop=${#loopList[*]}
	if [ "$nbLoop" != "0" ]; then
		OLDIFS=$IFS
		while [ "$nbLoop" != "0" ]; do
			currentLoop=${loopList[$(($nbLoop - 1))]}
			IFS=$'\ '
			set -- $currentLoop
			my_umount "$1"
			loop=${1##*\/}
			loopDev="/dev/${loop:0:5}"
			echo "loopDev=$loopDev"
			EXE "kpartx -d $loopDev 2>/dev/null"
			EXE "losetup -d $loopDev 2>/dev/null"
			nbLoop=$(($nbLoop - 1))
		done
	fi
}

cleanup() {
	cleanup_loopDevice

	my_umount "$MOUNT_IMGSFS_PATH"
	my_umount "$MOUNT_ROOTFS_PATH"
}

errorHandler() {
	echo -e $fontRed"Error from $(caller 0)$attrReset"
	cleanup
	exit
}

def_font_attributes
cleanup
my_mount

EXE sync

my_umount