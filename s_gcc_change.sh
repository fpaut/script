#!/bin/bash
gccpath=$1
dest=$HOME/bin/gcc
mkdir -p $dest
if [ ! -e $gccpath ]; then
	echo "$gccpath doesn't exists!"
	exit 1
fi
cd $gccpath
echo "These files will be linked in $dest"
ls

for file in $(ls); 
do
	rm $HOME/bin/$file 2>/dev/null
	CMD="ln -s $(pwd)/$file $dest/$file"
	echo $CMD; $CMD
done
