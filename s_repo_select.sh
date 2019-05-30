#!/bin/bash
set -u
echo "Select repo tools (aosp or sp)"
if [[ "$1" != "sp" && "$1" != "aosp" ]]; then
	echo "first parameter must be sp for starpeak, or aosp for... aosp"
	exit
fi
test -e $HOME/bin/repo
if [ "$?" = "0" ]; then
	rm $HOME/bin/repo
fi
case "$1" in
	aosp )
		ln -s $HOME/bin/aosp_repo $HOME/bin/repo
	;;
	sp )
		ln -s $HOME/bin/sp_repo $HOME/bin/repo
	;;
esac
echo "$1 selected"
