#!/bin/bash
TAR_FILE=$1
TMP_DIR=$(pwd)"/tmp"
if [ "$TAR_FILE" = "" ]; then
	echo "recreate a tar file preserving permission, extended attributes..."
	echo "#1 is the tar filename"
	exit 1
fi
if [ -e $TMP_DIR ]; then
	read -e -i 'Y' -p "folder '$TMP_DIR' exists, remove? (Y/n/q): "
	case $REPLY in
		n | N)
		;;
		y | Y)
			sudo rm -rf $TMP_DIR
		;;
		q | Q)
			exit
		;;
	esac
fi
if [ ! -e $TMP_DIR ]; then
	mkdir $TMP_DIR
fi
sudo tar --preserve-permissions --selinux --xattrs -xf $TAR_FILE -C $TMP_DIR
echo -e "File uncompressed in \n$TMP_DIR\n"
read -e -p "you can modify now this folder. press enter when finished to recompress..."

SUB_FOLDER=$(ls $TMP_DIR)
SUB_FOLDER=$(echo $SUB_FOLDER | sed ':a;N;$!ba;s/\n/ /g')
echo -e "SUB_FOLDER=$SUB_FOLDER"
cd $TMP_DIR
CMD="sudo tar --preserve-permissions --selinux --xattrs -cf tmp.tar $SUB_FOLDER"
eval $CMD
DIRNAME=$(dirname $TAR_FILE)
FILENAME=$(basename $TAR_FILE)
mv ../$TAR_FILE ../$DIRNAME/old_$FILENAME
mv ./tmp.tar ../$TAR_FILE
cd ..
