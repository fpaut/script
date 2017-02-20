#!/bin/bash
PKG=$@
thisscript=$(basename $0)
history_file=~/pkg_install.sh
errInstall_file=~/pkg_error.txt
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
BLUE="\e[34m"
CYAN="\e[96m"
WHITE="\e[97m"
ATTR_RESET="\e[0m"

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
	local installed=$(dpkg -s "$search" | grep "Status: " | grep "installed")
	if [ "$installed" != "" ]; then
		echo true; return 1;
	else
		return 0
	fi
}


for package in $PKG
do
	echo "Check if $package already installed..."
	if [ "$(already_installed "$package")" != "" ]; then
		echo "$package already installed..."
	else
                rm $errInstall_file
		echo "installing $package"
		CMD="sudo apt-get install -y $package 2>>$errInstall_file"
		echo $CMD
		eval $CMD
		if [ "$?" = "0" ]; then
			if [ "$(cat $history_file | grep -w "$package")" = "" ]; then
				echo "echo -e \"\\e[34m[$package]\\e[0m\"" >> $history_file
				echo -en "$thisscript $package\n" >> $history_file
			fi
		else
			echo -en "$CMD failed \n"
			cat $errInstall_file
			exit 1
		fi
	fi
done



