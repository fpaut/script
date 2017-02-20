#! /bin/bash
if [ "$#" -le 1 ]; then
	echo "#1 is tar name"
	echo "#2 is output (folder)"
	exit 1
fi

TAR_FILE=$1
OUTPUT=$2
if [ ! -e $OUTPUT ]; then
	mkdir $OUTPUT
fi
CMD="sudo tar --preserve-permissions --selinux --xattrs -xf $TAR_FILE -C $OUTPUT"
echo $CMD
eval $CMD
