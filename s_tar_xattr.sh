#! /bin/bash
if [ "$#" -le 1 ]; then
	echo "#1 is tar name"
	echo "#2,3,4... is content to compress"
	exit 1
fi

TAR_FILE=$1
shift
DATA_FILE=$@
CMD="sudo tar --preserve-permissions --selinux --xattrs -cf $TAR_FILE $DATA_FILE"
echo $CMD
eval $CMD
