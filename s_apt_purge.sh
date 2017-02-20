#!/bin/bash
PKG="$@"
history_file=~/pkg_install.sh

contains() {
	local search=$1
	local myarray=$2
	case $search in
		"${myarray[@]}")
			echo true;
			return 1;;
	esac
	return 0
}

already_installed() {
	local search=$1
	dpkg -s $search 1>/dev/null 2>/dev/null
	if [ "$?" = "0" ]; then
		echo true; return 1;
	else
		return 0
	fi
}


for package in $PKG
do
	echo "Check if $package installed..."
	if [ "$(already_installed "$package")" != "" ]; then
		echo "$package installed, removing..."
		CMD="sudo apt-get purge $package"; echo $CMD; $CMD
		if [ "$?" = "0" ]; then
			$(cat $history_file | grep -v "$package" > "$history_file"_tmp)
			rm $history_file
			mv "$history_file"_tmp $history_file
		else
			echo -en "$CMD failed \n"
			exit 1
		fi
	else
		echo "$package not installed!"
		exit 1
	fi
done



